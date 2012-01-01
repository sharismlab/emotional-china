###
  emotion.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/bigram'
  'cs!../text/trigram'
], (m, br, rc, bi, tr) ->

    emotions = [
        'joy', 'surprise', 'fear', 'sadness', 'disgust', 'anger', 'scorn',
        'distress', 'anxiety', 'serene', 'sincere', 'wish', 'pity', 'guilt',
        'admire', 'confusion', 'caution', 'fierce', 'trance'
    ]

    params =
        backend:
            type: 'Redis'
            options:
                hostname: rc.host
                port: rc.port
        thresholds:
            unrelated: 6
            weak: 1
            strong: 2
            stronger: 3
            strongest: 5
        def: 'unrelated'

    m.types = emotions
    m.options = ['unrelated', 'weak', 'strong', 'stronger', 'strongest']


    createBayes = (name) ->
        params.backend.options.name = name
        new br.BayesianClassifier(params)

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.trainForText = (type, text, category) ->
        if category == 'weak'
            bayeses[type].train(text, 'weak')
        if category == 'strong'
            bayeses[type].train(text, 'weak')
            bayeses[type].train(text, 'strong')
        if category == 'stronger'
            bayeses[type].train(text, 'weak')
            bayeses[type].train(text, 'strong')
            bayeses[type].train(text, 'stronger')
        if category == 'strongest'
            bayeses[type].train(text, 'weak')
            bayeses[type].train(text, 'strong')
            bayeses[type].train(text, 'stronger')
            bayeses[type].train(text, 'strongest')

    m.train = (type, text, category) ->
        m.trainForText type, (bi.apply text), category
        m.trainForText type, (tr.apply text), category

    m.trainAll = (text, categories) ->
        for type in emotions
            strength = categories[type]
            m.train(type, text, strength) if strength

    m

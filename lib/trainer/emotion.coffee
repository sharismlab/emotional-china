###
  emotion.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
  'cs!../text/trigram'
], (m, r, b, t) ->

    emotions = [
        'joy', 'surprise', 'fear', 'sadness', 'disgust', 'anger', 'scorn',
        'distress', 'anxiety', 'serene', 'sincere', 'wish', 'pity', 'guilt',
        'admire', 'confusion', 'caution', 'fierce', 'trance'
    ]

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 5
            weak: 4
            strong: 3
            stronger: 2
            strongest: 1
        def: 'unrelated'

    m.types = emotions
    m.options = ['unrelated', 'weak', 'strong', 'stronger', 'strongest']


    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.train = (type, text, category) -> bayeses[type].train((t.apply text), category)

    m.trainAll = (text, categories) ->
        for type in emotions
            strength = categories[type]
            m.train(type, text, strength) if strength

    m

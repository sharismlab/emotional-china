###
  emotion.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/segmentor'
], (m, br, rc, sg) ->

    emotions = [
        'joy',           'disgust',
        'like',          'distress',
        'wish',          'anxiety',
        'surprise',      'sadness',
        'admire',        'anger',
        'laments',       'fear',
        'sincere',       'fierce',
        'serene',        'envy',
        'caution',       'scorn',
        'pity',          'guilt',
        'confusion',     'trance',
    ]

    params =
        backend:
            type: 'Redis'
            options:
                hostname: rc.host
                port: rc.port
        thresholds:
            unrelated: 1
            weak: 3
            strong: 3
            stronger: 2
            strongest: 2
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
        sg.seg text, (doc) ->
            m.trainForText type, doc, category

    m.trainAll = (text, categories) ->
        for type in emotions
            strength = categories[type]
            m.train(type, text, strength) if strength

    m

###
  emotion.coffee
###
define [
  'exports'
  'underscore'
  'asyncblock'
  'brain'
  'cs!../../config/redis'
  'cs!../text/segmentor'
], (m, _, a, b , r, s) ->

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
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 1
            weak: 3
            strong: 3
            stronger: 2
            strongest: 2
        def: 'unrelated'

    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.classifyAll = (text, callback) ->
        s.seg text, (doc) ->
            a (flow) ->
                segs = doc
                flow.maxParallel = 1;
                try
                    for type in emotions
                        m.classify type, segs, flow.add(type)
                    categories = flow.wait()
                    callback(null, categories)
                catch err
                    callback(err, null)

    m.classify = (type, segs, callback) ->
        try
            bayeses[type].classify segs, (cat) ->
                callback null, cat
        catch err
            callback err, null

    m

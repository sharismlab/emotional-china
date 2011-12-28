###
  emotion.coffee
###
define [
  'exports'
  'asyncblock'
  'cs!../../config/redis'
  'brain'
], (m, a, r, b) ->

    emotions = ['joy', 'surprise', 'fear', 'sadness', 'digest', 'anger', 'slight']

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 1
            modest: 1
            strong: 1
            stronger: 1
            strongest: 1
        def: 'modest'

    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        a (flow) ->
            try
                for name in emotions
                    bayes = createBayes(name)
                    bayes.classify(text, flow.add(name))
                categories = flow.wait()
                callback(categories)
            catch err
                callback(err, null)

    m

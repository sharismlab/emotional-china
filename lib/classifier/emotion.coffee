###
  emotion.coffee
###
define [
  'exports'
  'asyncblock'
  'cs!../../config/redis'
  'brain'
], (m, a, r, b) ->

    emotions = ['neutral', 'joy', 'surprise', 'fear', 'sadness', 'digest', 'anger', 'slight']

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            weakest: 1
            weaker: 1
            weak: 1
            modest: 1
            strong: 1
            stronger: 1
            strongest: 1
        def: 'modest'

    createBayes = (name) ->
        params.options.name = name
        new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        a (flow) ->
            for name in emotions
                bayes = createBayes(name)
                bayes.classify(text, flow.add(name))
            categories = flow.wait()
            callback(null, categories)

    m

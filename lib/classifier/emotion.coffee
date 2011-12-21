###
  emotion.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
], (m, r, b) ->

    params =
        backend:
            type: 'Redis'
            params:
                hostname: r.host
                port: r.port
                name: 'emotion'
        thresholds:
            neurual: 1
            joy: 3
            surprise: 3
            fear: 3
            sadness: 3
            digest: 3
            anger: 3
            slight: 3
        def: 'neurual'

    m.type = 'emotion'
    m.options = ['neutral', 'joy', 'surprise', 'fear', 'sadness', 'digest', 'anger', 'slight']
    m.classify = (text, callback) ->
        bayes = new b.BayesianClassifier(params)
        bayes.classify(text, callback)

    m

###
  aboutness.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
], (m, r, b) ->

    options =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
                name: 'aboutness'
        thresholds:
            about: 3
            notabout: 1
        def: 'notabout'

    bayes = new b.BayesianClassifier(options)

    m.classify = (text) -> bayes.classify(text)

    m

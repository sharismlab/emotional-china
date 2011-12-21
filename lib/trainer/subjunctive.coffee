###
  subjunctive.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
] (m r b) ->

    options =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
                name: 'subjunctive'
        thresholds:
            yes: 3
            no: 1
        def: 'no'

    bayes = new b.BayesianClassifier(options)

    m.train = (text, category) -> bayes.train(text, category)

    m

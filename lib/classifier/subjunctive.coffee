###
  subjunctive.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
] (m r b) ->

    params =
        backend:
            type: 'Redis'
            params:
                hostname: r.host
                port: r.port
                name: 'subjunctive'
        thresholds:
            yes: 3
            no: 1
        def: 'no'

    m.type = 'subjunctive'
    m.options = ['yes', 'no']
    m.classify = (text, callback) ->
        bayes = new b.BayesianClassifier(params)
        bayes.classify(text, callback)

    m

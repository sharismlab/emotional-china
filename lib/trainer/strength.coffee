###
  strength.coffee
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
                name: 'strength'
        thresholds:
            weakest: 4
            weaker: 3
            weak: 2
            modest: 1
            strong: 2
            stronger: 3
            strongest: 4
        def: 'modest'

    bayes = new b.BayesianClassifier(options)

    m.train = (text, category) -> bayes.train(text, category)

    m

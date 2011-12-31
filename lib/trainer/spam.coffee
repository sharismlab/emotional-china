###
  aboutness.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
], (m, b, r) ->
    options =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
                name: 'spam'
        thresholds:
            spam: 3
            normal: 1
        def: 'normal'

    m.type = 'spam'
    m.options = ['spam', 'normal']

    bayes = new b.BayesianClassifier(options)
    m.train = (text, category) -> bayes.train(text, category)

    m

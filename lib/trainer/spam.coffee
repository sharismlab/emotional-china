###
  aboutness.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/trigram'
], (m, b, r, t) ->
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
    m.train = (text, category) -> bayes.train((t.apply text), category)

    m

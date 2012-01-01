###
  aboutness.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/bigram'
  'cs!../text/trigram'
], (m, br, rc, bi, tr) ->
    options =
        backend:
            type: 'Redis'
            options:
                hostname: rc.host
                port: rc.port
                name: 'spam'
        thresholds:
            spam: 3
            normal: 1
        def: 'normal'

    m.type = 'spam'
    m.options = ['spam', 'normal']

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        bayes.train((bi.apply text), category)
        bayes.train((tr.apply text), category)

    m

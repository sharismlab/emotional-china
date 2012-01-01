###
  subjunctive.coffee
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
                name: 'subjunctive'
        thresholds:
            positive: 1
            negative: 1
        def: 'negative'

    m.type = 'subjunctive'
    m.options = ['positive', 'negative']

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        bayes.train((bi.apply text), category)
        bayes.train((tr.apply text), category)

    m

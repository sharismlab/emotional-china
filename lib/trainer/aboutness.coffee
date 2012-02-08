###
  aboutness.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
  'cs!../text/segmentor'
], (m, br, rc, sg) ->
    options =
        backend:
            type: 'Redis'
            options:
                hostname: rc.host
                port: rc.port
                name: 'aboutness'
        thresholds:
            related: 3
            uncertain: 1
        def: 'uncertain'

    m.type = 'aboutness'
    m.options = ['related', 'uncertain']

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        sg.seg text, (doc) ->
            bayes.train doc, category

    m

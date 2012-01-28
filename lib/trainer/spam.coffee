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
                name: 'spam'
        thresholds:
            spam: 1
            normal: 5
        def: 'normal'

    m.type = 'spam'
    m.options = ['spam', 'normal']

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        sg.seg text, (doc) ->
           console.log doc
           bayes.train doc, category

    m

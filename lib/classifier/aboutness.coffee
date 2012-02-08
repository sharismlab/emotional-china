###
  aboutness.coffee
###
define [
  'exports'
  'underscore'
  'brain'
  'cs!../../config/redis'
  'cs!../text/segmentor'
], (m, _, b, r, s) ->
    params =
        backend:
            type: 'Redis'
            params:
                hostname: r.host
                port: r.port
                name: 'aboutness'
        thresholds:
            related: 3
            uncertain: 1
        def: 'uncertain'

    bayes = new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        s.seg text, (doc) ->
            try
                bayes.classify doc, (cat) ->
                    callback null, cat
            catch err
                callback err, null

    m

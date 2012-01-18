###
  subjunctive.coffee
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
                name: 'subjunctive'
        thresholds:
            positive: 1
            negative: 5
        def: 'negative'

    bayes = new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        s.seg text, (doc) ->
            try
                bayes.classify doc.split(' '), (cat) ->
                    console.log cat
                    callback null, cat
            catch err
                callback err, null

    m

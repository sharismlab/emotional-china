###
  subjunctive.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
], (m, r, b) ->
    params =
        backend:
            type: 'Redis'
            params:
                hostname: r.host
                port: r.port
                name: 'subjunctive'
        thresholds:
            positive: 3
            negative: 1
        def: 'negative'

    bayes = new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        try
            bayes.classify text, (cat) ->
                callback null, cat
        catch err
            callback err, null

    m

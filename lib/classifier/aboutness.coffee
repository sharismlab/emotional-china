###
  aboutness.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
  'cs!../text/trigram'
], (m, r, b, t) ->
    params =
        backend:
            type: 'Redis'
            params:
                hostname: r.host
                port: r.port
                name: 'aboutness'
        thresholds:
            me: 3
            you: 3
            it: 3
            me_you: 3
            me_it: 3
            you_me: 3
            you_it: 3
            it_me: 3
            it_you: 3
            uncertain: 1
        def: 'uncertain'

    bayes = new b.BayesianClassifier(params)

    m.classify = (text, callback) ->
        try
            bayes.classify (t.apply text), (cat) ->
                callback null, cat
        catch err
            callback err, null

    m

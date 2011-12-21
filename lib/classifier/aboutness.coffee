###
  aboutness.coffee
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

    m.type = 'aboutness'
    m.options = ['me', 'you', 'it', 'me_you', 'me_it', 'you_me', 'you_it', 'it_me', 'it_you', 'uncertain']
    m.classify = (text, callback) ->
        bayes = new b.BayesianClassifier(params)
        bayes.classify(text, callback)

    m

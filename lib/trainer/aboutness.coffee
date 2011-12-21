###
  aboutness.coffee
###
define [
  'exports'
  'brain'
  'cs!../../config/redis'
], (m, b, r) ->
    options =
        backend:
            type: 'Redis'
            options:
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
    m.train = (text, category) ->
        bayes = new b.BayesianClassifier(options)
        bayes.train(text, category)

    m

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

    bayes = new br.BayesianClassifier(options)
    m.train = (text, category) ->
        bayes.train((bi.apply text), category)
        bayes.train((tr.apply text), category)

    m

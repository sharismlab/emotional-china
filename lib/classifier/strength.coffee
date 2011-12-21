###
  strength.coffee
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
                name: 'strength'
        thresholds:
            weakest: 4
            weaker: 3
            weak: 2
            modest: 1
            strong: 2
            stronger: 3
            strongest: 4
        def: 'modest'

    m.type = 'strength'
    m.options = ['weakest', 'weaker', 'weak', 'modest', 'strong', 'stronger', 'strongest']
    m.classify = (text, callback) ->
        bayes = new b.BayesianClassifier(params)
        bayes.classify(text, callback)

    m

###
  emotion.coffee
###
define [
  'exports'
  'cs!../../config/redis'
  'brain'
], (m, r, b) ->

    emotions = ['joy', 'surprise', 'fear', 'sadness', 'digest', 'anger', 'slight']

    params =
        backend:
            type: 'Redis'
            options:
                hostname: r.host
                port: r.port
        thresholds:
            unrelated: 1
            modest: 1
            strong: 1
            stronger: 1
            strongest: 1
        def: 'modest'

    m.types = emotions
    m.options = ['unrelated', 'modest', 'strong', 'stronger', 'strongest']

    createBayes = (name) ->
        params.backend.options.name = name
        new b.BayesianClassifier(params)

    m.train = (text, categories) ->
        try
            for name in emotions
                strength = categories[name]
                if strength
                    bayes = createBayes(name)
                    bayes.train(text, strength)
        catch err
            callback err, null

    m

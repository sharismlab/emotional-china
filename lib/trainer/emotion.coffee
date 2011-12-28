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

    bayeses = {}
    for name in emotions
        bayeses[name] = createBayes(name)

    m.train = (type, text, category) -> bayeses[type].train(text, category)

    m.trainAll = (text, categories) ->
        for type in emotions
            strength = categories[type]
            m.train(type, text, strength) if strength

    m

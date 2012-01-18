###
  emo.coffee
###
define [
  'exports'
  'cs!./config/index'
  'cs!./scripts/web-server'
  'cs!./scripts/weibo-crawler'
  'cs!./scripts/bayes-trainer'
  'cs!./sandbox/dump'
  'cs!./sandbox/train'
  'cs!./sandbox/inspect'
], (m, config, web, crawler, trainer, dump, train, inspect) ->

    m.main = (args...) ->
        web.run(config) if args[0] == 'web'
        crawler.run(config) if args[0] == 'crawler'
        trainer.run(config) if args[0] == 'trainer'

        if args[0] == 'sandbox'
            dump.run(config)    if args[1] == 'dump'
            train.run(config)   if args[1] == 'train'
            inspect.run(config) if args[1] == 'inspect'

    m

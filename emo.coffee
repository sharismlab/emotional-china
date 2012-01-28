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
        config.cwd = args[0]
        web.run(config) if args[1] == 'web'
        crawler.run(config) if args[1] == 'crawler'
        trainer.run(config) if args[1] == 'trainer'

        if args[1] == 'sandbox'
            dump.run(config)    if args[2] == 'dump'
            train.run(config)   if args[2] == 'train'
            inspect.run(config) if args[2] == 'inspect'

    m

###
  emo.coffee
###
define [
  'exports'
  'cs!./config/index'
  'cs!./scripts/web-server'
  'cs!./scripts/weibo-crawler'
  'cs!./scripts/bayes-trainer'
], (m, config, web, crawler, trainer) ->

    m.main = (args...) ->
        web.run(config) if args[0] == 'web'
        crawler.run(config) if args[0] == 'crawler'
        trainer.run(config) if args[0] == 'trainer'

    m

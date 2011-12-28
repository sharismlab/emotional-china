###
  emo.coffee
###
define [
  'exports'
  'cs!./config/index'
  'cs!./scripts/web-server'
  'cs!./scripts/weibo-crawler'
], (m, config, web, crawler) ->

    m.main = (args...) ->
        if args[0] == 'web'
            web.run(config)
        if args[0] == 'crawler'
            crawler.run(config)

    m

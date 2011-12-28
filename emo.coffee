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
        web.main(config)

    m

###
  emo.coffee
###
define [
  'exports'
  'cs!./scripts/web-server'
  'cs!./scripts/weibo-crawler'
], (m, w, c) ->

    m.main = (args...) ->
        ctx = {}
        w.main(ctx)

    m

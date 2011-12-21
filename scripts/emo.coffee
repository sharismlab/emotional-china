###
  emo.coffee
###
define [
  'exports'
  'cs!./web-server'
  'cs!./weibo-crawler'
], (m, w, c) ->

    m.main = (args...) ->
        ctx = {}
        c.main(ctx)

    m

###
  weibo-crawler.coffee
###
define [
  'exports'
  'underscore'
  'cs!../lib/crawler/crawler'
], (m, _, c) ->

    m.run = (ctx) ->
        c.run ctx, (error, msg) ->
            if error
                console.log error
            else
                console.log msg.text

    m

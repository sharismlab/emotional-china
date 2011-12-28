###
  weibo-crawler.coffee
###
define [
  'exports'
  'cs!../lib/crawler/crawler'
], (m, c) ->

    m.run = (ctx) ->
        c.run ctx, (error, msg) ->
            if error
                console.log error
            else
                console.log msg.text

    m

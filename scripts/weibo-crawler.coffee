###
  weibo-crawler.coffee
###
define [
  'exports'
  'cs!../config/weibo'
  'cs!../lib/crawler/crawler'
], (m, w, c) ->

    m.main = (ctx) ->
        ctx.weibo = w
        console.log ctx
        c.run ctx, (error, data, response) ->
            if error
                console.log error
            else
                console.log data

    m

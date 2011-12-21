###
  weibo-crawler.coffee
###
define [
  'exports'
  'underscore'
  'cs!../config/weibo'
  'cs!../lib/crawler/crawler'
], (m, _, w, c) ->

    m.main = (ctx) ->
        ctx.weibo = w
        c.run ctx, (error, data, response) ->
            if error
                console.log error
            else
                _(data).chain().map((msg) -> msg.text).each(
                    (text) -> console.log text
                )

    m

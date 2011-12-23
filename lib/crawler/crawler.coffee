###
  crawler.coffee
###
define [
  'exports'
  'weibo'
], (m, w) ->

    tapi = w.tapi

    m.run = (ctx, callback) ->
        config = ctx.weibo
        tapi.init 'tsina', config.appkey, config.secret, config.oauth_callback_url
        tapi.public_timeline {}, (error, data, response) ->
            callback error, data, response

    m.fetchText = (ctx, callback) ->
        config = ctx.weibo
        tapi.init 'tsina', config.appkey, config.secret, config.oauth_callback_url
        tapi.public_timeline {count: 1, page: 1}, (error, data, response) ->
            if error
                callback error
            else if data and data.length > 0
                callback error, data[0].text

    m


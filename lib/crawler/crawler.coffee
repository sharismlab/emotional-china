###
  crawler.coffee
###
define [
  'exports'
  'underscore'
  'weibo'
  'cs!./queue'
], (m, _, w, q) ->

    tapi = w.tapi

    m.run = (ctx, callback) ->
        q.init(ctx)

        config = ctx.weibo
        tapi.init 'tsina', config.appkey, config.secret, config.oauth_callback_url

        gap = 30000 # 30 seconds
        check = ->
            q.size (err, len) ->
                if not err and len >= 0
                    gap = 100 * len
            setTimeout(check, 10000)

        fetch = ->
            tapi.public_timeline {count: 10, page: 1}, (error, data, response) ->
                if error
                    callback error
                else if data and data.length > 0
                    _.each data, (item) ->
                        q.enqueue item
                        callback error, item
            setTimeout(fetch, gap)

        check()
        fetch()

    m


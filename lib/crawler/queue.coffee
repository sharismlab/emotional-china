###
  crawler.coffee
###
define [
  'exports'
  'underscore'
  'redis'
], (m, _, r) ->

    key = 'q:weibo'
    redis = null

    m.init = (ctx) ->
        config = ctx.redis
        redis = r.createClient(config.port, config.host, config.options)

    m.enqueue = (o) ->
        redis.rpush key, JSON.stringify(o)

    m.dequeue = (callback) ->
        redis.lpop key, callback

    m.fetchText = (callback) ->
        redis.lpop key, (err, value) ->
            if not err and value
                callback(err, JSON.parse(value).text)

    m.size = (callback) ->
        redis.llen key, callback

    m


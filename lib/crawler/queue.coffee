###
  queue.coffee
###
define [
  'exports'
  'redis'
  'crypto'
], (m, r, c) ->

    redis  = null

    key    = 'q:weibo'
    prefix = 'k:weibo:'

    m.init = (ctx) ->
        config = ctx.redis
        redis = r.createClient(config.port, config.host, config.options)

    unique = (s, callback) ->
        md5sum = c.createHash('md5')
        md5sum.update(s)
        hash = prefix + md5sum.digest('hex').substring(0, 16)
        redis.exists hash, (err, flag) ->
            if !flag
                redis.set hash, '1'
                redis.expire hash, 600
            callback err, !flag

    m.enqueue = (o) ->
        if o
            val = JSON.stringify o
            unique val, (err, flag) ->
                redis.rpush key, val if flag

    m.dequeue = (callback) ->
        redis.lpop key, (err, val) ->
            if err
                callback err, null
            else
                if val
                    callback null, JSON.parse val
                else
                    callback null, null

    m.fetchText = (callback) ->
        redis.lpop key, (err, value) ->
            if not err and value
                callback err, JSON.parse(value).text
            else
                callback null, null

    m.size = (callback) ->
        redis.llen key, callback

    m


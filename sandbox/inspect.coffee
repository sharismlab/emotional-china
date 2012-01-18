###
  dump.coffee
###
define [
  'exports'
  'underscore'
  'redis'
], (m, _, r) ->

    m.run = (ctx) ->
        config = ctx.redis
        redis = r.createClient(config.port, config.host, config.options)
        redis.hgetall 'brain_bayes_words_joy', (err, values) ->
            console.log values

    m


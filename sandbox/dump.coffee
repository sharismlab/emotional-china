###
  dump.coffee
###
define [
  'exports'
  'underscore'
  'cs!../lib/crawler/queue'
  'cs!../config/index'
], (m, _, queue, ctx) ->

    m.run = (callback) ->
        queue.init(ctx)

        gap = 300 # 3 seconds
        check = ->
            queue.size (err, len) ->
                if not err and len >= 0
                    gap = (500 - len) if len < 500
            setTimeout(check, 100)

        handle = ->
            queue.fetchText (err, text) ->
                return if !text
                console.log text
                console.log '---------------------'
            setTimeout(handle, gap)

        check()
        handle()

    m


###
  queue.coffee
###
define [
  'exports'
  'cs!./queue'
  'cs!./aboutness'
  'cs!./subjunctive'
  'cs!./emotion'
  'cs!./spam'
], (m, q, a, s, e, sp) ->

    m.run = (ctx) ->
        q.init(ctx)

        gap = 3000 # 3 seconds
        check = ->
            q.size (err, len) ->
                if not err and len >= 0
                    gap = 10 * (300 - len)
            setTimeout(check, 500)

        trainers = {
            aboutness: a
            subjunctive: s
            spam: sp
        }

        handle = ->
            q.dequeue (err, val) ->
                return if !val
                { type: type, text: text, category: cat } = val
                return if !type
                console.log type, cat, text
                trainer = trainers[type]
                if trainer
                    trainer.train text, cat
                else
                    e.train type, text, cat
            setTimeout(handle, gap)

        check()
        handle()

    m


###
  queue.coffee
###
define [
  'exports'
  'cs!./queue'
  'cs!./aboutness'
  'cs!./subjunctive'
  'cs!./emotion'
], (m, q, a, s, e) ->

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
            emotion: e
        }

        handle = ->
            q.dequeue (err, val) ->
                { type: type, text: text, category: cat } = val
                console.log type, cat, text
                if type
                    trainer = trainers[type]
                    if trainer
                        trainer.train text, cat
                    else
                        e.train type, text, cat
            setTimeout(handle, gap)

        check()
        handle()

    m


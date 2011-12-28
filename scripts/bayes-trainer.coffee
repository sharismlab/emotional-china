###
  bayes-trainer.coffee
###
define [
  'exports'
  'cs!../lib/trainer/trainer'
], (m, t) ->

    m.run = (ctx) ->
        t.run ctx

    m

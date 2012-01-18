###
  segmentor.coffee
###
define [
  'exports'
  'nseg'
  'cs!./sina-at'
  'cs!./sina-smily'
  'cs!./sina-tag'
], (m, nseg, at, smily, tag) ->

    m.seg = (text, callback) ->
        seg = nseg.normal({ lexers: [at, smily, tag] })
        seg text, callback

    m

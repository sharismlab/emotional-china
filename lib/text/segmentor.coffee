###
  segmentor.coffee
###
define [
  'exports'
  'nseg'
  'cs!./filter'
  'cs!./sina-at'
  'cs!./sina-smily'
  'cs!./sina-tag'
], (m, nseg, flt, at, smily, tag) ->

    m.seg = (text, callback) ->
        seg = nseg.normal({ lexers: [at, smily, tag] })
        cb = (doc) ->
            callback flt.filter(doc.split(' '))
        seg text, cb

    m

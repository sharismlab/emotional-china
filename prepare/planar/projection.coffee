###
  projection.coffee
###
define [
  'underscore',
  'exports'
], (_, exports) ->

    unify = (p) ->
        s = 0
        for i in [0...(p.length)]
            s += p[i] * p[i]
        _.map p, (v) ->
            v / Math.sqrt(s)

    px = unify([1 / 1, 1 / 2, 1 / 3, 1 / 5, 1 / 8, 1 / 13, 1 / 21])
    py = unify([1 / 1, 1 / 21, 1 / 13, 1 / 8, 1 / 5, 1 / 3, 1 / 2])

    exports.project = (points)->
        _.map points, (p) ->
            x = 0
            y = 0
            p = unify(p)
            for i in [0...7]
                x += p[i] * px[i]
                y += p[i] * py[i]
            [x, y]

    exports


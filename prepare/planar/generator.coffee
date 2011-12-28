###
  generator.coffee
###
define [
  'exports'
], (exports) ->

    acceptable = (p) ->
        n = 0
        for i in [0..7]
            n++ if p[i] == 0
        n > 4

    exports.gen = ->
        points = []
        for joy in [0..4]
            for sup in [0..4]
                for fea in [0..4]
                    for sad in [0..4]
                        for dgt in [0..4]
                            for ang in [0..4]
                                for ang in [0..4]
                                    for slt in [0..4]
                                        if acceptable([joy, sup, fea, sad, dgt, ang, slt])
                                            points.push([joy / 4 - 2, sup / 4 - 2, fea / 4 - 2, sad / 4 - 2, dgt / 4 - 2, ang / 4 - 2, slt / 4 - 2])
        points

    exports


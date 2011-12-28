###
  viewer.coffee

  view for generation
###
define [
  'underscore',
  'exports'
], (_, viewer) ->

    canvas = document.getElementById("canvas")
    context = canvas.getContext("2d")
    canvas.width = 512
    canvas.height = 512

    pow = (i) ->
        p = 1
        for j in [0...i]
            p *= 2
        p

    color = (point) ->

        b = 0
        g = 0
        r = 0

        for i in [0..7]
            val = point[i] + 2
            if 0 == val
                b += pow(i)
            else
                if 1 == val
                    g += pow(i)
                else
                    r += pow(i)

        hexR = Math.round(r).toString(16)
        hexR = '0' + hexR if hexR.length == 1
        hexG = Math.round(g).toString(16)
        hexG = '0' + hexG if hexG.length == 1
        hexB = Math.round(b).toString(16)
        hexB = '0' + hexB if hexB.length == 1

        "#" + hexR + hexG + hexB

    viewer.paint = (points, pos) ->
        context.clearRect(0, 0, 512, 512)
        console.log(points[1])
        console.log(color(points[1]))
        console.log(pos[1])
        for i in [0..(4 * 4 * 4 * 4 * 4 * 4 * 4)]
            context.fillStyle = color(points[i])
            context.fillRect(Math.floor(1024 + 1024 * pos[i][0]), Math.floor(1024 + 1024 * pos[i][1]), 2, 2)

    viewer
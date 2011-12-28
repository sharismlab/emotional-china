###
  csmain.coffee

  link for this section:
  http://playground.wahlque.org/tutorials/graphics/001-terrain-gen
###
define [
  'underscore'
  'domReady'
  'cs!projection'
  'cs!generator'
  'cs!viewer'
], (_, domReady, p, g, v) ->

    domReady ->
        points = g.gen()
        v.paint(points, p.project(points))

       true

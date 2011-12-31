###
  trigram.coffee
###
define [
  'exports'
], (m) ->

    m.apply = (text) ->
        trigram = [];
        for i in [0..(text.length - 3)]
             trigram.push(text.substring(i, i + 3));
        trigram

    m

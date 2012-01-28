###
  segmentor.coffee
###
define [
  'exports'
  'underscore'
], (m, _) ->

    m.filter = (words) ->
        _.reject words, (word) ->
            word == '' or word == ' ' or word == ',' or word == '，' or word == '.' or word == '。' or word == '的' or word == '了' or word == '是' or word[1] == '@'

    m

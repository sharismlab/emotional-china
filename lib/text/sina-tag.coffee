###
  sina-tag.coffee
###
define [
  'exports'
], (m) ->

    m.accept = (ch, undecided, next) ->
        if (ch == '#' or undecided and undecided.substring(0, 1) == '#')
            if (undecided.length > 1 and ch == '#')
                return 1;
            else
                return 0;
        else
            return -1;

    m

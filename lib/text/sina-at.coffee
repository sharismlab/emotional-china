###
  sina-at.coffee
###
define [
  'exports'
], (m) ->

    m.accept = (ch, undecided, next) ->
        if (ch == '@' or undecided and undecided.substring(0, 1) == '@')
            if (next != ' ')
                return 0;
            else
                return 1;
        else
            return -1;

    m

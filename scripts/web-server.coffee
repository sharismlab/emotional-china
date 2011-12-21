###
  main.coffee
###
define [
  'exports'
  'zappa'
], (m, z) ->

    m.main = ->
        z ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'

            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @get '/': -> @render 'index'

    m

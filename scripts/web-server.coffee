###
  main.coffee
###
define [
  'exports'
  'zappa'
  'cs!../lib/crawler/crawler'
  'cs!../lib/trainer/aboutness'
  'cs!../lib/trainer/emotion'
  'cs!../lib/trainer/strength'
  'cs!../lib/trainer/subjunctive'
  'cs!../lib/classifier/aboutness'
  'cs!../lib/classifier/emotion'
  'cs!../lib/classifier/strength'
  'cs!../lib/classifier/subjunctive'
], (m, z, crwl, trnabt, trnemt, trnstn, trnsub, clsabt, clsemt, clsstn, clssub) ->

    m.main = (ctx) ->
        z ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'

            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @get '/': -> @render 'index'

            @get '/train': ->
                @render 'train'

            @get '/test': ->
                @render 'test'

            @get '/train/aboutness': ->
                crwl.fetchText (err, text) =>
                    if not err
                        data =
                            type: trnabt.type
                            options: trnabt.options
                            text: text
                        @send data
            @get '/train/emotion': ->
                crwl.fetchText (err, text) =>
                    if not err
                        data =
                            type: trnemt.type
                            options: trnemt.options
                            text: text
                        @send data
            @get '/train/strength': ->
                crwl.fetchText (err, text) =>
                    if not err
                        data =
                            type: trnstn.type
                            options: trnstn.options
                            text: text
                        @send data
            @get '/train/subjunctive': ->
                crwl.fetchText (err, text) =>
                    if not err
                        data =
                            type: trnsub.type
                            options: trnsub.options
                            text: text
                        @send data

            @get '/test/aboutness': ->
                crwl.fetchText (err, text) =>
                    if not err
                        clsabt.classify text (error, cat) =>
                            if not error
                                data =
                                    type: trnabt.type
                                    options: trnabt.options
                                    text: text
                                    category: cat
                                @send data
            @get '/test/emotion': ->
                crwl.fetchText (err, text) =>
                    if not err
                        clsemt.classify text (error, cat) =>
                            if not error
                                data =
                                    type: trnemt.type
                                    options: trnemt.options
                                    text: text
                                    category: cat
                                @send data
            @get '/test/strength': ->
                crwl.fetchText (err, text) =>
                    if not err
                        clsstn.classify text (error, cat) =>
                            if not error
                                data =
                                    type: trnstn.type
                                    options: trnstn.options
                                    text: text
                                    category: cat
                                @send data
            @get '/test/subjunctive': ->
                crwl.fetchText (err, text) =>
                    if not err
                        clsasub.classify text (error, cat) =>
                            if not error
                                data =
                                    type: trnsub.type
                                    options: trnsub.options
                                    text: text
                                    category: cat
                                @send data

            @post '/train/aboutness': ->
                trnabt.train @body.text @body.category

            @post '/train/emotion': ->
                trnemt.train @body.text @body.category

            @post '/train/strength': ->
                trnstn.train @body.text @body.category

            @post '/train/subjunctive': ->
                trnsub.train @body.text @body.category

    m

###
  main.coffee
###
define [
  'exports'
  'zappa'
  'cs!../config/weibo'
  'cs!../config/labels'
  'cs!../lib/crawler/crawler'
  'cs!../lib/trainer/aboutness'
  'cs!../lib/trainer/subjunctive'
  'cs!../lib/classifier/aboutness'
  'cs!../lib/classifier/subjunctive'
  'cs!../lib/trainer/emotion'
  'cs!../lib/classifier/emotion'
], ( m, z, w, l, crwl,
     trnabt, trnsub, clsabt, clssub,
     trnemt, clsemt
   ) ->

    m.main = (ctx) ->
        ctx.weibo = w
        ctx.labels = l
        z ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'

            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @get '/': -> @render 'index'

            @view index: ->
                doctype 5
                html ->
                  head ->
                    meta charset: 'utf-8'
                    title '表情中国'
                    link rel: 'stylesheet', href: '/styles/style.css'
                    script src: '/zappa/jquery.js'
                    script src: '/zappa/sammy.js'
                    script src: '/zappa/zappa.js'
                    script src: '/javascripts/slides.js'
                    script src: '/index.js'
                  body ->
                    h1 '表情中国'
                    div id: 'msg'
                    div id: 'slide'
                    ul ->
                      li -> a href: '#/train', -> '训练'
                      li -> a href: '#/test',  -> '测试'

            @client '/index.js': ->
                @get '#/train': ->
                @get '#/test': ->

            @get '/api/train/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        data =
                            type: trnabt.type
                            options: trnabt.options
                            text: text
                        @send data
            @get '/api/train/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        data =
                            types: trnemt.types
                            options: trnemt.options
                            text: text
                        @send data
            @get '/api/train/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        data =
                            type: trnsub.type
                            options: trnsub.options
                            text: text
                        @send data

            @get '/api/test/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsabt.classify text, (error, cat) =>
                            if not error
                                data =
                                    type: trnabt.type
                                    options: trnabt.options
                                    text: text
                                    category: cat
                                @send data
            @get '/api/test/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsemt.classify text, (error, cats) =>
                            if not error
                                data =
                                    type: trnemt.types
                                    options: trnemt.options
                                    text: text
                                    categories: cats
                                @send data
            @get '/api/test/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clssub.classify text, (error, cat) =>
                            if not error
                                data =
                                    type: trnsub.type
                                    options: trnsub.options
                                    text: text
                                    category: cat
                                @send data

            @post '/api/train/aboutness': ->
                trnabt.train @body.text, @body.category

            @post '/api/train/emotion': ->
                trnemt.train @body.text, @body.categories

            @post '/api/train/subjunctive': ->
                trnsub.train @body.text, @body.category

    m

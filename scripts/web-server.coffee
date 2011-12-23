###
  main.coffee
###
define [
  'exports'
  'underscore'
  'zappa'
  'cs!../config/weibo'
  'cs!../config/labels'
  'cs!../lib/crawler/crawler'
  'cs!../lib/trainer/aboutness'
  'cs!../lib/classifier/aboutness'
  'cs!../lib/trainer/subjunctive'
  'cs!../lib/classifier/subjunctive'
  'cs!../lib/trainer/emotion'
  'cs!../lib/classifier/emotion'
], ( m, _, z, w, l, crwl, trnabt, clsabt, trnsub, clssub, trnemt, clsemt) ->

    m.main = (ctx) ->
        ctx.weibo = w
        ctx.labels = l
        z ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'
            @enable 'serve jquery', 'serve sammy'
            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @get '/': -> @render 'index': {layout: no}

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
                    script src: '/javascripts/underscore-min.js'
                    script src: '/index.js'
                  body ->
                    h1 '表情中国'
                    div id: 'msg'
                    div id: 'slider', ->
                      ul ->
                        li -> a href: '#/train', -> '下一个训练'
                        li -> a href: '#/test',  -> '下一个测试'
                    div id: 'main'

            @client '/index.js': ->
                choice = ->
                    val = Math.random()
                    if val < 1.0 / 3
                        'aboutness'
                    else
                        if val < 2.0 / 3
                            'subjunctive'
                        else
                            'emotion'

                @app.use Sammy.Template, 'tmpl'

                @app.get '#/train', ->
                    @load '/api/train/' + choice(), (data) =>
                        @load '/templates/train.tmpl', (tmpl) =>
                            (@$element '#main').html _.template(tmpl, data)

                @app.get '#/test', ->
                    @load '/api/train/' + choice(), (data) =>
                        @load '/templates/test.tmpl', (tmpl) =>
                            (@$element '#main').html _.template(tmpl, data)

            localize = (a)->
                if a
                    l[a]
                else
                    l['uncertain']

            @get '/api/train/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            type: l[trnabt.type]
                            options: _.map trnabt.options, localize
                            text: text
            @get '/api/train/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            types: _.map trnemt.types, localize
                            options: _.map trnemt.options, localize
                            text: text
            @get '/api/train/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            type: l[trnsub.type]
                            options: _.map trnsub.options, localize
                            text: text

            @get '/api/test/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsabt.classify text, (error, cat) =>
                            if not error
                                @send
                                    type: l[trnabt.type]
                                    options: _.map trnabt.options, localize
                                    text: text
                                    category: l[cat]
            @get '/api/test/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsemt.classify text, (error, cats) =>
                            if not error
                                @send
                                    types: _.map trnemt.types, localize
                                    options: _.map trnemt.options, localize
                                    text: text
                                    categories: _.map trnemt.types, (n) -> localize(cats[n])
            @get '/api/test/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clssub.classify text, (error, cat) =>
                            if not error
                                @send
                                    type: l[trnsub.type]
                                    options: _.map trnsub.options, localize
                                    text: text
                                    category: l[cat]

            @post '/api/train/aboutness': ->
                trnabt.train @body.text, @body.category

            @post '/api/train/emotion': ->
                trnemt.train @body.text, @body.categories

            @post '/api/train/subjunctive': ->
                trnsub.train @body.text, @body.category

    m

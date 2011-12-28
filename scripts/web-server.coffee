###
  main.coffee
###
define [
  'exports'
  'underscore'
  'zappa'
  'cs!../lib/crawler/crawler'
  'cs!../lib/trainer/aboutness'
  'cs!../lib/classifier/aboutness'
  'cs!../lib/trainer/subjunctive'
  'cs!../lib/classifier/subjunctive'
  'cs!../lib/trainer/emotion'
  'cs!../lib/classifier/emotion'
], ( m, _, z, crwl, trnabt, clsabt, trnsub, clssub, trnemt, clsemt) ->

    m.main = (ctx) ->
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
                    link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic'
                    link rel: 'stylesheet', href: '/styles/reset.css'
                    link rel: 'stylesheet', href: '/styles/main.css'
                    link rel: 'stylesheet', href: '/styles/app.css'
                    script src: '/zappa/jquery.js'
                    script src: '/zappa/sammy.js'
                    script src: '/zappa/zappa.js'
                    script src: '/javascripts/underscore-min.js'
                    script src: '/index.js'
                  body ->
                    div id: 'msg'
                    div id: 'reveal', ->
                        div class: 'slides', ->
                            section -> h3 -> '表情中国'
                            section -> h3 -> '说明'
                            section -> ''
                            section -> ''
                        aside class: 'controls', ->
                            a class:'left',  href:'#left', -> '◄'
                            a class:'right', href:'#right', -> '►'
                            a class:'up',    href:'#up', -> '▲'
                            a class:'down',  href:'#down', -> '▼'
                        div class: 'progress', -> span -> ''
                    script src: '/javascripts/reveal.js'
                    script src: '/lib/highlight.js'
                    script src: '/start.js'

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

                @app.bind 'test', (e) ->
                    type = choice()
                    @load "/api/test/#{type}" , (data) =>
                        @load '/templates/test.tmpl', (tmpl) =>
                            ($ '.slides>section>section.last').remove()
                            subslides = ($ ($ '.slides>section')[2])
                            id = Math.floor(1000 * Math.random())
                            data.id = id
                            subslides.append _.template(tmpl, data)
                            subslides.find('section:lt(1)').remove() if subslides.children().length > 8
                            ($ '.opt').click (e) =>
                                target = $ e.target
                                tid = target.attr 'id'
                                segments = tid.split '-'
                                if parseInt(segments[2]) == id
                                    target.html '✔'
                                    $.post "/api/train/#{type}", {
                                        category: segments[1]
                                        text: ($ "#text-#{id}").text()
                                    }

                @app.bind 'train', (e) ->
                    type = choice()
                    @load "/api/train/#{type}", (data) =>
                        @load '/templates/train.tmpl', (tmpl) =>
                            ($ '.slides>section>section.last').remove()
                            subslides = ($ ($ '.slides>section')[3])
                            id = Math.floor(1000 * Math.random())
                            data.id = id
                            subslides.append _.template(tmpl, data)
                            subslides.find('section:lt(1)').remove() if subslides.children().length > 8
                            ($ '.opt').click (e) =>
                                target = $ e.target
                                tid = target.attr 'id'
                                segments = tid.split '-'
                                if parseInt(segments[2]) == id
                                    target.html '✔'
                                    $.post "/api/train/#{type}", {
                                        category: segments[1]
                                        text: ($ "#text-#{id}").text()
                                    }

            @client '/start.js': ->
                $ =>
                    @app.run()

                    @app.trigger 'test'
                    @app.trigger 'test'
                    @app.trigger 'test'
                    @app.trigger 'train'
                    @app.trigger 'train'
                    @app.trigger 'train'

                    cur  = [null, null, 'test', 'train']
                    Reveal.initialize
                        controls: true,
                        progress: true,
                        rollingLinks: true
                        beforeLeft: (indexh, indexv) =>
                            @app.trigger cur[indexh + 1]
                        beforeDown: (indexh, indexv) =>
                            @app.trigger cur[indexh]

                    hljs.initHighlightingOnLoad()

            localize = (a) ->
                if a
                    ctx.labels[a]
                else
                    ctx.labels['uncertain']

            reverseMap = {}
            for key in _.keys ctx.labels
                reverseMap[ctx.labels[key]] = key
            reverse = (a) ->
                if a
                    reverseMap[a]
                else
                    'uncertain'

            @get '/api/train/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            type: localize(trnabt.type)
                            options: _.map trnabt.options, localize
                            text: text
                    else
                        console.log err
                        @send {}
            @get '/api/train/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            types: _.map trnemt.types, localize
                            options: _.map trnemt.options, localize
                            text: text
                    else
                        console.log err
                        @send {}
            @get '/api/train/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        @send
                            type: localize(trnsub.type)
                            options: _.map trnsub.options, localize
                            text: text
                    else
                        console.log err
                        @send {}

            @get '/api/test/aboutness': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsabt.classify text, (cat) =>
                            @send
                                type: localize(trnabt.type)
                                options: _.map trnabt.options, localize
                                text: text
                                category: localize(cat)
            @get '/api/test/emotion': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clsemt.classify text, (cats) =>
                            categories = {}
                            for n in _.keys(trnemt.types)
                                categories[localize(n)] = localize(cats[n])
                            @send
                                types: _.map trnemt.types, localize
                                options: _.map trnemt.options, localize
                                text: text
                                categories: categories
            @get '/api/test/subjunctive': ->
                crwl.fetchText ctx, (err, text) =>
                    if not err
                        clssub.classify text, (cat) =>
                            @send
                                type: localize(trnsub.type)
                                options: _.map trnsub.options, localize
                                text: text
                                category: localize(cat)

            @post '/api/train/aboutness': ->
                console.log @body.text, @body.category
                trnabt.train @body.text, reverse @body.category

            @post '/api/train/emotion': ->
                console.log @body.text, @body.category
                trnemt.train @body.text, reverse @body.categories

            @post '/api/train/subjunctive': ->
                console.log @body.text, @body.category
                trnsub.train @body.text, reverse @body.category

    m

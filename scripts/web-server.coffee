###
  main.coffee
###
define [
  'exports'
  'underscore'
  'zappa'
  'cs!../lib/crawler/queue'
  'cs!../lib/trainer/queue'
  'cs!../lib/trainer/aboutness'
  'cs!../lib/classifier/aboutness'
  'cs!../lib/trainer/subjunctive'
  'cs!../lib/classifier/subjunctive'
  'cs!../lib/trainer/spam'
  'cs!../lib/classifier/spam'
  'cs!../lib/trainer/emotion'
  'cs!../lib/classifier/emotion'
], ( m, _, z, cq, tq, trnabt, clsabt, trnsub, clssub, trnspam, clsspam, trnemt, clsemt) ->

    m.run = (ctx) ->
        cq.init ctx
        tq.init ctx

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
                    if val < 0.1
                        'aboutness'
                    else if 0.1 < val < 0.2
                        'subjunctive'
                    else if 0.2 < val < 0.4
                        'spam'
                    else
                        'emotion'

                @app.bind 'test', (e) ->
                    type = choice()
                    @load "/api/test/#{type}" , { cache: false }, (data) =>
                        @load '/templates/test.tmpl', (tmpl) =>
                            ($ '.slides>section>section.last').remove()
                            subslides = ($ ($ '.slides>section')[2])
                            id = Math.floor(1000 * Math.random())
                            data.id = id
                            subslides.append _.template(tmpl, data)
                            subslides.find('section:lt(1)').remove() if subslides.children().length > 3
                            ($ '.opt').click (e) =>
                                target = $ e.target
                                tid = target.attr 'id'
                                segments = tid.split '-'
                                if parseInt(segments[3]) == id
                                    tr = target.parents('tr')
                                    tr = $(tr[0])
                                    $(tr).find("span:contains('✔')").html '❍'
                                    target.html '✔'
                                    $.post "/api/train/#{type}", {
                                        type: segments[1]
                                        category: segments[2]
                                        text: ($ "#text-#{id}").text()
                                    }

                @app.bind 'train', (e) ->
                    type = choice()
                    @load "/api/train/#{type}", { cache: false }, (data) =>
                        @load '/templates/train.tmpl', (tmpl) =>
                            ($ '.slides>section>section.last').remove()
                            subslides = ($ ($ '.slides>section')[3])
                            id = Math.floor(1000 * Math.random())
                            data.id = id
                            subslides.append _.template(tmpl, data)
                            subslides.find('section:lt(1)').remove() if subslides.children().length > 3
                            ($ '.opt').click (e) =>
                                target = $ e.target
                                tid = target.attr 'id'
                                segments = tid.split '-'
                                if parseInt(segments[3]) == id
                                    tr = target.parents('tr')
                                    $(tr).find("span:contains('✔')").html '❍'
                                    target.html '✔'
                                    $.post "/api/train/#{type}", {
                                        type: segments[1]
                                        category: segments[2]
                                        text: ($ "#text-#{id}").text()
                                    }

            @client '/start.js': ->
                $ =>
                    @app.run()
                    $.ajaxSetup cache: false

                    for i in [0..4]
                        @app.trigger 'test'
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
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        @send
                            type: localize(trnabt.type)
                            options: _.map trnabt.options, localize
                            text: text

            @get '/api/train/subjunctive': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        @send
                            type: localize(trnsub.type)
                            options: _.map trnsub.options, localize
                            text: text

            @get '/api/train/spam': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        @send
                            type: localize(trnspam.type)
                            options: _.map trnspam.options, localize
                            text: text

            @get '/api/train/emotion': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        @send
                            types: _.map trnemt.types, localize
                            options: _.map trnemt.options, localize
                            text: text

            @get '/api/test/aboutness': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        clsabt.classify text, (error, cat) =>
                            @send
                                type: localize(trnabt.type)
                                options: _.map trnabt.options, localize
                                text: text
                                category: localize(cat)

            @get '/api/test/subjunctive': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        clssub.classify text, (error, cat) =>
                            @send
                                type: localize(trnsub.type)
                                options: _.map trnsub.options, localize
                                text: text
                                category: localize(cat)

            @get '/api/test/spam': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        clsspam.classify text, (error, cat) =>
                            @send
                                type: localize(trnspam.type)
                                options: _.map trnspam.options, localize
                                text: text
                                category: localize(cat)

            @get '/api/test/emotion': ->
                @response.header 'Cache-Control', 'no-cache'
                @response.header 'Expires', 'Fri, 31 Dec 1998 12:00:00 GMT'
                cq.fetchText (err, text) =>
                    if err
                        console.log err
                        @send {}
                    else
                        clsemt.classifyAll text, (error, cats) =>
                            if error or !cats
                                console.log error
                                @send {}
                            else
                                categories = {}
                                for n in _.keys(cats)
                                    categories[localize(n)] = localize(cats[n])
                                @send
                                    types: _.map trnemt.types, localize
                                    options: _.map trnemt.options, localize
                                    text: text
                                    categories: categories

            @post '/api/train/aboutness': ->
                console.log @body.text, @body.category
                tq.enqueue type: 'aboutness', text: @body.text, category: (reverse @body.category)

            @post '/api/train/subjunctive': ->
                console.log @body.text, @body.category
                tq.enqueue type: 'subjunctive', text: @body.text, category: (reverse @body.category)

            @post '/api/train/spam': ->
                console.log @body.text, @body.category
                tq.enqueue type: 'spam', text: @body.text, category: (reverse @body.category)

            @post '/api/train/emotion': ->
                console.log @body.text, @body.type, @body.category
                tq.enqueue type: (reverse @body.type), text: @body.text, category: (reverse @body.category)

    m

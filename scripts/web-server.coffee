###
  main.coffee
###
define [
  'exports'
  'require'
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
], ( m, require, _, z, cq, tq, trnabt, clsabt, trnsub, clssub, trnspam, clsspam, trnemt, clsemt) ->

    m.run = (ctx) ->
        cq.init ctx
        tq.init ctx

        z 'localhost', 4000, ->
            @use 'bodyParser', 'methodOverride', @app.router, 'static'
            @enable 'serve zappa'
            @configure
              development: => @use errorHandler: {dumpExceptions: on}
              production: => @use 'errorHandler'

            @clientjs = (name) =>
              func = require('../clients/' + name)
              obj  = []
              obj['/' + name + '.js'] = func
              @coffee obj

            @clientjs 'index'
            @clientjs 'start'

            @get '/': -> @render 'index': {layout: no}

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
                            if error
                                console.log error
                                @send {}
                            else
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
                            if error
                                console.log error
                                @send {}
                            else
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
                            if error
                                console.log error
                                @send {}
                            else
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
                console.log @body.type, @body.category, @body.text
                tq.enqueue type: 'aboutness', text: @body.text, category: (reverse @body.category), =>
                    @send {}

            @post '/api/train/subjunctive': ->
                console.log @body.type, @body.category, @body.text
                tq.enqueue type: 'subjunctive', text: @body.text, category: (reverse @body.category), =>
                    @send {}

            @post '/api/train/spam': ->
                console.log @body.type, @body.category, @body.text
                tq.enqueue type: 'spam', text: @body.text, category: (reverse @body.category), =>
                    @send {}

            @post '/api/train/emotion': ->
                console.log @body.type, @body.category, @body.text
                tq.enqueue type: (reverse @body.type), text: @body.text, category: (reverse @body.category), =>
                    @send {}

    m

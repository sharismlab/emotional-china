doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title '表情中国'
    link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic'
    link rel: 'stylesheet', href: '/styles/reset.css'
    link rel: 'stylesheet', href: '/styles/main.css'
    link rel: 'stylesheet', href: '/styles/app.css'
    script src: '/javascripts/jquery.min.js'
    script src: '/javascripts/sammy.min.js'
    script src: '/javascripts/underscore-min.js'
    script src: '/javascripts/zappa.js'
    script src: '/index.js'
  body ->
    div id: 'msg'
    div id: 'reveal', ->
        div class: 'slides', ->
            section -> h3 -> '表情中国'
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

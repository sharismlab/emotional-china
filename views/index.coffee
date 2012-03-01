@title = "Emo-China"

body ->
    div id: 'msg'
    div id: 'reveal', ->
        div class: 'slides', ->
            section -> h3 -> 'Emo-China'
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

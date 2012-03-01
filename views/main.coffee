doctype 5
html ->
  comment 'This page is rapidly becoming not-so-simple'
  comment "[if lt IE 7]> <html class=\"no-js lt-ie9 lt-ie8 lt-ie7\" lang=\"en\"> <![endif]"
  comment "[if IE 7]>    <html class=\"no-js lt-ie9 lt-ie8\" lang=\"en\"> <![endif]"
  comment "[if IE 8]>    <html class=\"no-js lt-ie9\" lang=\"en\"> <![endif]"
  comment "[if gt IE 8]> <!--> <html class='no-js' lang='en'> <!--<![endif]"
  head ->
    meta charset: "utf-8"
    meta "http-equiv": "X-UA-Compatible", content: "IE=edge,chrome=1"
    title @title if @title
    meta name: "description", content: ""
    meta name: "viewport", content: "width=device-width"
    # link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=Lato:400,700,400italic,700italic'
    link rel: "stylesheet", href: "css/boilerplate.css"
    link rel: "stylesheet", href: "css/style.css"
    comment '[if lte IE 9]><link rel="stylesheet" href="css/ie.css" type="text/css" media="screen" /><![endif]'
    link rel: "stylesheet", href: "css/1140.css"
    if @stylesheets
      for s in @stylesheets
        link rel: 'stylesheet', href: 'css/' + s + '.css'
    if @stylesheet
      link(rel: 'stylesheet', href: 'css/' + @stylesheet + '.css')
      
    script src: "/js/libs/modernizr-2.5.3.min.js"
    script src: '/js/zappa.js'
    # script src: '/index.js'
  body ->
      comment "[if lt IE 7]><p class=chromeframe>Your browser is <em>ancient!</em> <a href=\'http://browsehappy.com/\'>Upgrade to a different browser</a> or <a href=\'http://www.google.com/chromeframe/?redirect=true\'>install Google Chrome Frame</a> to experience this site.</p><![endif]"
    div id: 'outerContainer' , ->
      header ->
        nav ->
          ul id: 'nav', class:'centred', ->
            li class: 'menu-item', ->
              a class:'left',  href:'/', -> 'Home'
            li class: 'menu-item', ->
              a class:'left',  href:'/', -> 'Login'
            li class: 'menu-item', ->
              a class:'left',  href:'/About', -> 'About'
            li class: 'menu-item', ->
              a class:'left',  href:'/test', -> 'd3'
            ul id: 'sns', ->
              li ->
                a class:'weibo',  href:'http://www.weibo.com/sharismlab', -> 'Weibo'
              li ->
                a  class:'twitter',  href:'http://www.twitter.com/sharismlab', -> 'Twitter'
    
    
      div role:'main', ->
        @body
    
      footer
    script ->
      text "window.jQuery || document.write('"
      script src: "/js/libs/jquery-1.7.1.min.js", "<\\/script>')"
      script src: "/js/plugins.js"
      script src: "/js/script.js"
      if @scripts
        for s in @scripts
          script src: 'js/' + s + '.js'
      script @script  if @script
      script """
      
          var _gaq=[['_setAccount','UA-XXXXX-X'],['_trackPageview']];
      
          (function(d,t){var g=d.createElement(t),s=d.getElementsByTagName(t)[0];
      
          g.src=('https:'==location.protocol?'//ssl':'//www')+'.google-analytics.com/ga.js';
      
          s.parentNode.insertBefore(g,s)}(document,'script'));
      
        
      """

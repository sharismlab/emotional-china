@title = "About"

@stylesheet = "about"
@scripts = ['libs/jquery.scrollto', 'about/about','d3/d3', 'd3/d3.layout', 'about/emochord', 'libs/jquery-ui-1.8.17.custom.min','about/grimace','libs/kinetic','about/menu' ]
@script = '''

'''

body ->
  div id:'particle', class:'navig'


  section id: 'slider', ->
    div id: "mask", ->

      div class:'slide', id:"one", ->
        div class:'one content container', ->
            div class:"row" , ->
                h2 -> 'Train a robot feeling'
                div class:"fourcol", ->
                  'How to make a robot feel sad or joyful?'
                div class:"fourcol", ->
                  h3 -> 'Select a feeling'
                  ul id:"buttons", ->
                    li ->
                      span class:'slidercaption', ->'Joy'
                      div class:'slider', id: 'joy'
                    
                    li ->
                      span class:'slidercaption', ->'Surprise'
                      div class:'slider', id: 'surprise'

                    li ->
                      span class:'slidercaption', ->'Fear'
                      div class:'slider', id: 'fear'

                    li ->
                      span class:'slidercaption', ->'Sadness'
                      div class:'slider', id: 'sadness'

                    li ->
                      span class:'slidercaption', ->'Disgust'
                      div class:'slider', id: 'disgust'


                    li ->
                      span class:'slidercaption', ->'Anger'
                      div class:'slider', id: 'anger'
                      
                      
                div class:"fourcol  last", ->
                  '''
                <div id="grimace_wheel">
			
		</div>
		<div id="grimace_wrapper">
			<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
				codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=9,0,0,0"
				width="320" height="300" id="Grimace" align="left">
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="allowFullScreen" value="false" />
			<param name="movie" value="Grimace.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<embed src="/flash/grimace/Grimace.swf" quality="high" bgcolor="#ffffff"
				width="360" height="300" name="Grimace" align="left"
				allowScriptAccess="sameDomain" allowFullScreen="false"
				type="application/x-shockwave-flash"
				pluginspage="http://www.macromedia.com/go/getflashplayer" />
			</object>
		</div>
		'''


      div class:'slide', id:"two", ->
        div class:'two content container', ->
            div class:"row" , ->
              h2 -> 'Explore feelings complexity'
              div class:"threecol", ->
                
                p "this is a complex thing"
              div class:"sixcol", ->
                div id:'chart'
              
              div class:"threecol last", ->
                h3 -> 'Click on the chart'
                p id:"feeling-name", ->
                  'Feeling name'

           
      div class:'slide', id:"three", ->
        div class:'three content container', ->
           div class:"row" , ->
              h2 -> 'Using Math to explore emotions'
              div class:"threecol", ->
                
                p -> 'We are investigating feelings and emotions using probabilities'
              div id: 'theorem', class:"threecol", ->
                img src:'/img/about/bayes_theorem.png'
              div class:"threecol", ->
                'Here comes some text about Bayes and his theorem'
              div class:"threecol last", ->
                img src:'/img/about/Thomas_Bayes.gif'

      div class:'slide', id:"four", ->
        div class:'four content container', ->
           div class:"row" , ->
              h2 -> 'Crowdsource research'
              div class:"threecol", ->
                p -> 'Blablba social brain'

                h3 -> 'Towards social brain'
                p -> 'Blablba social brain'

              div id: class:"ninecol last", ->
               img src:'/img/about/brain.svg'


      div class:'slide', id:"five", ->
        div class:'five content container', ->
           div class:"row" , ->
              h2 -> 'Sharism Lab'
              div class:"fourcol", ->
                p -> 'How do we share ?'
                
              div class:"fourcol", ->
                h3 -> 'Join us online'
                p -> 'and gEt updated'
                div class : 'sns', ->
                  a class:'sns-link',  href:'http://www.weibo.com/sharismlab', -> 
                    img src: 'img/sns/Weibo_48x48.png', alt : 'Weibo'
                  a  class:'sns-link',  href:'http://www.twitter.com/sharismlab', -> 
                    img src: 'img/sns/Twitter_48x48.png', alt : 'Twitter'
                  a  class:'sns-link',  href:'http://www.facebook.com/sharismlab', -> 
                    img src: 'img/sns/FaceBook_48x48.png', alt : 'Facebook'

                
                

              div class:"newsletter fourcol last ", ->
                h3 -> 'Get our updates'
                p -> 'approx. 1 post per week'
                
                 
                 
                '''
                <form action="http://feedburner.google.com/fb/a/mailverify" method="post" target="popupwindow" onsubmit="window.open('http://feedburner.google.com/fb/a/mailverify?uri=SharismLab', 'popupwindow', 'scrollbars=yes,width=550,height=520');return true">
                
                <p><input type="text" class="feedburn" name="email"/></p>
                <input type="hidden" value="SharismLab" name="uri"/>
                <input type="hidden" name="loc" value="en_US"/>
                <input type="submit" value="Subscribe" /></form>
                '''



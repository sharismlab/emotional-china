@title = "About"

@stylesheet = "about"
@scripts = ['libs/jquery.scrollto', 'about/about','d3/d3', 'd3/d3.layout', 'about/emochord', 'libs/jquery-ui-1.8.17.custom.min','about/grimace']
@script = '''

'''

body ->

  section id: 'slider', ->
    div id: "mask", ->

      div class:'slide', id:"one", ->
        div class:'three content', ->
          div class:'two content container', ->
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
				width="320" height="360" id="Grimace" align="left">
			<param name="allowScriptAccess" value="sameDomain" />
			<param name="allowFullScreen" value="false" />
			<param name="movie" value="Grimace.swf" />
			<param name="quality" value="high" />
			<param name="bgcolor" value="#ffffff" />
			<embed src="/flash/grimace/Grimace.swf" quality="high" bgcolor="#ffffff"
				width="360" height="360" name="Grimace" align="left"
				allowScriptAccess="sameDomain" allowFullScreen="false"
				type="application/x-shockwave-flash"
				pluginspage="http://www.macromedia.com/go/getflashplayer" />
			</object>
		</div>
		'''


      div class:'slide', id:"two", ->
        div class:'two content container', ->
            div class:"row" , ->
              h2 -> 'Explore feelings Complexity'
              div class:"fourcol", ->
                
                h3 -> 'Select a feeling'
                p id:"feeling-name", ->
                  'Feeling name'
             
              div class:"eightcol last", ->
                div id:'chart'
           
      div class:'slide', id:"three", ->
        div class:'three content container', ->
           div class:"row" , ->
              h2 -> 'Using Math to talk about emotions'
              div class:"threecol", ->
                
                p -> 'We are investigating feelings and emotions using probabilities'
              div id: 'theorem', class:"threecol", ->
                img src:'/img/about/bayes_theorem.png'
              div class:"threecol", ->
                'Here comes some text about Bayes and his theorem'
              div class:"threecol last", ->
                img src:'/img/about/Thomas_Bayes.gif'

      div class:'slide', id:"four", ->
        div class:'four content', ->
          "four"
          
  nav class:"navig", ->
    div class:"buttons", ->
      div class:"one", ->
        a class:'panel one',  href:'#one', -> 'One'
      div class:"two", ->
        a class:'panel two',  href:'#two', -> 'Two'
      div class:"three", ->
        a class:'panel three',  href:'#three', -> 'Three'
      div class:"four", ->
        a class:'panel four selected',  href:'#four', -> 'Four'

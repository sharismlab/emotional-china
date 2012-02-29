module.exports = => zappa.run ->
  choice = ->
      val = Math.random()
      if val < 0.1
          'aboutness'
      else if 0.1 <= val < 0.2
          'subjunctive'
      else if 0.2 <= val < 0.5
          'spam'
      else
          'emotion'

  @app.bind 'test', (e) ->
      type = choice()
      @load '/templates/test.tmpl', (tmpl) =>
          @load "/api/test/#{type}" , { cache: false }, (data) =>
              ($ '.slides>section>section.last').remove()
              subslides = ($ ($ '.slides>section')[1])
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

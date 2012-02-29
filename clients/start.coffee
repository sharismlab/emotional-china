module.exports = => zappa.run ->
  $ =>
      @app.run()
      $.ajaxSetup cache: false

      for i in [0..4]
          @app.trigger 'test'

      cur  = [null, 'test']
      Reveal.initialize
          controls: true,
          progress: true,
          rollingLinks: true
          beforeLeft: (indexh, indexv) =>
              @app.trigger cur[indexh + 1]
          beforeDown: (indexh, indexv) =>
              @app.trigger cur[indexh]

      hljs.initHighlightingOnLoad()

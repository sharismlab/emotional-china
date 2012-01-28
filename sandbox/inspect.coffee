###
  dump.coffee
###
define [
  'exports'
  'underscore'
  'redis'
  'fs'
], (m, _, r, fs) ->

    zfill = (num, size) ->
        s = num + ""
        while (s.length < size)
            s = "0" + s
        s

    sfill = (s, size) ->
        while (s.length < size)
            s = " " + s
        s

    keys = [
        'aboutness'
        'joy'
        'surprise'
        'fear'
        'sadness'
        'disgust'
        'anger'
        'scorn'
        'distress'
        'anxiety'
        'serene'
        'sincere'
        'wish'
        'pity'
        'guilt'
        'admire'
        'envy'
        'like'
        'laments'
        'confusion'
        'caution'
        'fierce'
        'trance'
        'subjunctive'
        'spam'
    ]

    m.run = (ctx) ->
        cwd = ctx.cwd
        config = ctx.redis
        redis = r.createClient(config.port, config.host, config.options)

        _.each keys, (key) ->
            redis.hgetall 'brain_bayes_words_' + key, (err, values) ->
                tuples = _.chain(values).keys().map((key) ->
                    keys = key.split('____')
                    [values[key], keys[1], keys[0]]
                ).sortBy((data) ->
                    zfill(10000 - data[0], 5) + sfill(data[1], 10) + ' ' + data[2]
                ).map((data) ->
                    zfill(data[0], 5) + sfill(data[1], 10) + '    ' + data[2]
                ).value()

                fs.writeFile cwd + '/temp/' + key, tuples.join('\n'), ->
                    throw err if (err)
                    console.log(key + ' is saved!')

                true

    m


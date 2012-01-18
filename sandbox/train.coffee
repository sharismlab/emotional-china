###
  dump.coffee
###
define [
  'exports'
  'underscore'
  'fs'
  'cs!../lib/trainer/queue'
  'cs!../config/index'
], (m, _, fs, queue, ctx) ->

    m.run = (callback) ->
        queue.init(ctx)

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

        emotions = [
            'joy',           'disgust',
            'like',          'distress',
            'wish',          'anxiety',
            'surprise',      'sadness',
            'admire',        'anger',
            'laments',       'fear',
            'sincere',       'fierce',
            'serene',        'envy',
            'caution',       'scorn',
            'pity',          'guilt',
            'confusion',     'trance',
        ]

        fs.readFile "#{process.cwd()}/data/train.txt", 'utf-8', (err, data) ->
            throw err if err
            for block in data.split('---------------------')
                lines = _.filter(block.split('\n'), (line) -> line)
                len = lines.length
                if len > 1
                    i = 1
                    text = lines[0]
                    voted = []
                    scores = []
                    unvoted = []
                    while i < len
                        classify = lines[i].split(' ')
                        if classify[0] == '广告'
                            queue.enqueue({text: text, type: 'spam', category: 'spam'})
                            queue.enqueue({text: text, type: 'aboutness', category: 'uncertain'})
                            queue.enqueue({text: text, type: 'sunjunctive', category: 'negative'})
                            for emotion in emotions
                                queue.enqueue({text: text, type: emotion, category: 'unrelated'})
                        else if classify[0] == '不确定'
                            queue.enqueue({text: text, type: 'spam', category: 'normal'})
                            queue.enqueue({text: text, type: 'aboutness', category: 'uncertain'})
                            queue.enqueue({text: text, type: 'sunjunctive', category: 'negative'})
                            for emotion in emotions
                                queue.enqueue({text: text, type: emotion, category: 'unrelated'})
                        else if classify[0] == '虚拟或假设'
                            queue.enqueue({text: text, type: 'spam', category: 'normal'})
                            queue.enqueue({text: text, type: 'aboutness', category: 'uncertain'})
                            queue.enqueue({text: text, type: 'sunjunctive', category: 'positive'})
                            for emotion in emotions
                                queue.enqueue({text: text, type: emotion, category: 'unrelated'})
                        else
                            queue.enqueue({text: text, type: 'spam', category: 'normal'})
                            queue.enqueue({text: text, type: 'aboutness', category: 'related'})
                            queue.enqueue({text: text, type: 'sunjunctive', category: 'negative'})
                            for emotion in emotions
                                if localize(emotion) == classify[0]
                                    voted.push emotion
                                    scores.push reverse(classify[1])
                                else
                                    unvoted.push emotion
                        i++

                    _.each voted, (emotion, index) ->
                        category = scores[index]
                        if category == 'weak'
                            queue.enqueue {text: text, type: emotion, category: 'weak'}
                        if category == 'strong'
                            queue.enqueue {text: text, type: emotion, category: 'weak'}
                            queue.enqueue {text: text, type: emotion, category: 'strong'}
                        if category == 'stronger'
                            queue.enqueue {text: text, type: emotion, category: 'weak'}
                            queue.enqueue {text: text, type: emotion, category: 'strong'}
                            queue.enqueue {text: text, type: emotion, category: 'stronger'}
                        if category == 'strongest'
                            queue.enqueue {text: text, type: emotion, category: 'weak'}
                            queue.enqueue {text: text, type: emotion, category: 'strong'}
                            queue.enqueue {text: text, type: emotion, category: 'stronger'}
                            queue.enqueue {text: text, type: emotion, category: 'strongest'}
                    _.each unvoted, (emotion) ->
                        queue.enqueue {text: text, type: emotion, category: 'unrelated'}
            true

    m


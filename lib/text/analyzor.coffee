###
  analyzor.coffee
###
define [
  'exports'
  'underscore'
  'cs!segmentor'
], (m, _, s) ->

    isAt = (char) ->
        char == '@' or char == '＠'

    isHash = (char) ->
        char == '#' or char == '＃'

    isSpace = (char) ->
        char == ' ' or char == '　'

    isNumber = (char) ->
        '0' <= char <= '9'

    isLatin = (char) ->
        'a' <= char <= 'z' or  'A' <= char <= 'Z'

    isChinese = (char) ->
        '㐀' <= char <= '䶵' or '一' <= char <= '拿' or  '挀' <= char <= '矿' or  '砀' <= char <= '賿' or  '贀' <= char <= '鿋'

    appendNoSpace = (substr, text, pos) ->
        char = text[pos]
        if isSpace(char) or pos == text.length - 1
            [substr, pos + 1, char, true]
        else
            substr = substr + char
            appendNoSpace substr, text, pos + 1

    appendNoHash = (substr, text, pos) ->
        char = text[pos]
        if isHash(char) or pos == text.length - 1
            [substr, pos + 1, char, true]
        else
            substr = substr + char
            appendNoHash substr, text, pos + 1

    appendChinese = (substr, text, pos) ->
        char = text[pos]
        if !isChinese(char)
            [substr, pos, char, true]
        else
            substr = substr + char
            appendChinese substr, text, pos + 1

    appendLatin = (substr, text, pos) ->
        char = text[pos]
        if !isLatin(char) or pos == text.length - 1
            [substr, pos + 1, char, true]
        else
            substr = substr + char
            appendLatin substr, text, pos + 1

    appendNumber = (substr, text, pos) ->
        char = text[pos]
        if !isNumber(char) or pos == text.length - 1
            [substr, pos, char, true]
        else
            substr = substr + '' + char if substr.length < 10
            appendNumber substr, text, pos + 1


    gen = (text, pos) ->
        char = text[pos]
        if isAt(char)
            appendNoSpace(char, text, pos + 1)
        else if isHash(char)
            appendNoHash(char, text, pos + 1)
        else if isChinese(char)
            appendChinese(char, text, pos + 1)
        else if isLatin(char)
            appendLatin(char, text, pos + 1)
        else if isNumber(char)
            appendNumber(char, text, pos + 1)
        else
            [char, pos + 1, text[pos + 1], false]

    m.apply = (text) ->
        return if !text
        i = 0
        len = text.length
        segments = []
        while i < len
            char = text[i]
            [substr, next, nextChar, skip] = gen(text, i)
            if !isSpace(substr)
                substr = m.apply(substr) if isChinese(substr[0])
                segments.push(substr)
            if skip
                i = next
            else
                i = i + 1
        console.log segments
        _.flatten(segments)

    m

###
  trigram.coffee
###
define [
  'exports'
], (m) ->

    isLatin = (char) ->
        '0' <= char <= '9' and 'a' <= char <= 'z' and  'A' <= char <= 'Z'

    isChinese = (char) ->
        '㐀' <= char <= '䶵' and '一' <= char <= '拿' and  '挀' <= char <= '矿' and  '砀' <= char <= '賿' and  '贀' <= char <= '鿋'

    appendChinese = (substr, text, pos) ->
        char = text[pos]
        if !isChinese(char)
            [substr, pos, char]
        else
            substr = substr + char
            pos = pos + 1
            char = text[pos]
            if !isChinese(char)
                [substr, pos, char]
            else
                substr = substr + char
                pos = pos + 1
                char = text[pos]
                [substr, pos, char]

    appendLatin = (substr, text, pos) ->
        char = text[pos]
        if !isLatin(char)
            [substr, pos + 1, char]
        else
            substr = substr + char
            appendLatin substr, text, pos + 1

    gen = (text, pos) ->
        char = text[pos]
        if isChinese(char)
            appendChinese(char, text, pos + 1)
        else if isLatin(char)
            appendLatin(char, text, pos + 1)
        else
            [char, pos + 1, text[pos + 1]]

    m.apply = (text) ->
        i = 0
        len = text.length
        trigram = []
        while i < len
            [substr, next, nextChar] = gen(text, i)
            if !isSpace(substr)
                trigram.push(substr)
            i = next
        console.log trigram
        trigram

    m

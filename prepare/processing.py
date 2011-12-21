#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
import string
import re

s = unicode('　', 'utf-8')
d = unicode('，', 'utf-8')
sep = re.compile('\s|\t|,|' + s + '|' + d, flags=re.UNICODE)

words = []
f = codecs.open('vocabularies.txt', 'r', 'utf-8')
for line in f.readlines():
    line = unicode(line)
    words.extend(sep.split(line))

f = open('vocabularies.txt', 'w')
for w in sorted(set(words)):
    w = w.strip()
    if w != '':
        f.write(unicode(w + '\n').encode( "utf-8" ))


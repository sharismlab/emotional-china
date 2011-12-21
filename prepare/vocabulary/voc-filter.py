#!/usr/bin/env python
# -*- coding: utf-8 -*-#

import os
import re
import codecs
import httplib
import urllib
import random
import string
import time

from pyquery import PyQuery as pq

class MyOpener(urllib.URLopener):
      version = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.99 Safari/535.1'
      def read(self, url):
          try:
              handle = self.open(url)
              return handle.read()
          except IOError, e:
              if e.args[1] == 301 or e.args[1] == 302:
                  url = e.args[3]['Location']
                  print 'redirect: ' + url
                  return self.read(url)
              return '<html><body id="bodyContent"> </body></html>'

ggl = 'http://www.google.com/search?tbm=nws&hl=zh-CN&q='
dgt = re.compile('(\d|,)+', flags=re.UNICODE)
sep = re.compile(' |,', flags=re.UNICODE)
def query(q, result):
    p = '"' + q + '"'
    fetch_url = ggl + urllib.pathname2url(p.encode('utf-8'))
    d = pq(url=fetch_url, opener=lambda url: MyOpener().open(url).read())
    d = pq(d.html())
    txt = d.find('#resultStats').html()
    if txt != None:
        m = dgt.search(txt)
        if m != None:
            s = q + '\t' + string.join(sep.split(m.group(0)), '')
            print s
            result.write(s)

f = codecs.open('vocabularies.txt', 'r', 'utf-8')
r = codecs.open('result.txt', 'w', 'utf-8')
for line in f.readlines():
    line = unicode(line)
    query(line.strip(), r)
    time.sleep(random.uniform(10, 30))

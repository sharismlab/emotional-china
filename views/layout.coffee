doctype 5
html ->
  head ->
    meta charset: 'utf-8'
    title '表情中国'
    link rel: 'stylesheet', href: '/styles/style.css'
  body ->
    h1 '表情中国'
    div id: 'msg'
    @body

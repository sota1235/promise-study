## HTMLを取得してtitleを取り出してsayで読み上げる
## いろいろなPromiseライブラリを混ぜて使ってみる

request = require 'request'
cheerio = require 'cheerio'
{exec} = require 'child_process'

{Promise} = require 'es6-promise'
Q = require 'q'
Bluebird = require 'bluebird'

urls = [
  'http://shokai.org'
  'そんなURLはない'
  'https://github.com'
  'https://github.com/robots.txt'
  'https://google.co.jp'
]

getHtml = (url) ->
  console.log "getHtml(#{url})"
  return new Promise (resolve, reject) -> # es6-promise
    request url, (err, res, body) ->
      if err or res.statusCode isnt 200
        reject(err or "statusCode: #{res.statusCode}")
      resolve body

getTitle = (html) ->
  console.log "getTitle(html)"
  return new Bluebird (resolve, reject) -> # Bluebirdを使う
    $ = cheerio.load html
    if title = $('title').text()
      resolve title
      return
    reject 'title not found'

speech = (txt) ->
  console.log "speech(#{txt})"
  return new Q.Promise (resolve, reject) -> # Qを使う
    exec "say #{txt}", (err, stdout, stderr) ->
      if err
        reject(txt)
        return
      resolve(txt)

for url in urls
  do (url) ->
    getHtml url
    .then getTitle
    .then speech
    .then (title) ->
      console.log   "!!OK #{url} - #{title}"
    .catch (err) ->
      console.error "!!ERROR #{url} - #{err}"

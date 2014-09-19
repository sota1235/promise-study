## HTMLを（1つずつ）取得してtitleを取り出してsayで読み上げる
## いろいろなPromiseライブラリを混ぜて使ってみる
## HTTPリクエストするのは3000 msecごと
## 途中でエラーがあったら5000 msec待ってから、次のHTTPリクエストする

request = require 'request'
cheerio = require 'cheerio'
{exec}  = require 'child_process'

process.env.DEBUG ||= '*'
debug = require('debug')('promise-study')


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
  debug "getHtml(#{url})"
  return new Promise (resolve, reject) ->
    request url, (err, res, body) ->
      if err or res.statusCode isnt 200
        reject(err or "statusCode: #{res.statusCode}")
      resolve body

getTitle = (html) ->
  debug "getTitle(html)"
  return new Bluebird (resolve, reject) ->
    $ = cheerio.load html
    if title = $('title').text()
      resolve title
      return
    reject 'title not found'

speech = (txt) ->
  debug "speech(#{txt})"
  return new Promise (resolve, reject) ->
    exec "say #{txt}", (err, stdout, stderr) ->
      if err
        reject(txt)
        return
      resolve(txt)

Bluebird.each urls, (url) ->
  getHtml url
  .then getTitle
  .then speech
  .then (title) ->
    return new Promise (resolve) ->
      debug "wait 3000 msec"
      setTimeout ->
        debug "wait done"
        debug   "!!OK #{url} - #{title}"
        resolve()
      , 3000
  .catch (err) ->
    return new Promise (resolve, reject) ->
      debug "!!ERROR #{url} - #{err}"
      debug "wait 5000 msec for Error"
      setTimeout ->
        debug "wait done"
        resolve()
      , 5000

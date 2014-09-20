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
Q = require('q')
Bluebird = require 'bluebird'

urls = [
  'http://shokai.org'
  'そんなURLはない' # URLじゃない文字列。requestの例外を発生させるため
  'https://github.com'
  'https://github.com/robots.txt' # HTMLが返ってこないURL。titleタグ取得のエラーを起こすため
  'https://google.co.jp'
]

# HTML本文を取得するPromise
# URLが間違っていたりすると失敗する
getHtml = (url) ->
  debug "getHtml(#{url})"
  return new Q.Promise (resolve, reject) -> # Qを使う
    request url, (err, res, body) ->
      if err or res.statusCode isnt 200
        return reject(err or "statusCode: #{res.statusCode}")
      resolve body

# HTMLからタイトルを取得するPromise
# HTMLじゃなければ失敗する
getTitle = (html) ->
  debug "getTitle(html)"
  return new Bluebird (resolve, reject) -> # Bluebirdを使う
    $ = cheerio.load html
    if title = $('title').text()
      return resolve title
    reject 'title not found'

# 音声読み上げするPromise
speech = (txt) ->
  debug "speech(#{txt})"
  return new Promise (resolve, reject) -> # es6-promiseを使う
    exec "say #{txt}", (err, stdout, stderr) ->
      return reject(txt) if err
      resolve(txt)

# URLリストをBluebird.eachで1つずつ処理する
Bluebird.each urls, (url) ->
  getHtml url
  .then getTitle
  .then speech
  .then (title) ->
    return new Q.Promise (resolve) ->  # Qを使う
      debug "wait 3000 msec"
      # 3秒待ってから次のURLの処理へ
      setTimeout ->
        debug "wait done"
        debug "!!OK #{url} - #{title}"
        resolve()
      , 3000
  .catch (err) ->
    return new Promise (resolve, reject) ->  # es6-promiseを使う
      debug "!!ERROR #{url} - #{err}"
      debug "wait 5000 msec for Error"
      # どこかでエラーあったら5秒待つ
      setTimeout ->
        debug "wait done"
        resolve()
      , 5000

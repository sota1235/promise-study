## Errorのスタックトレースを見る

Promise = require 'bluebird'
# Promise.longStackTraces()

# Q = require('q')
# Q.longStackSupport = true

a = {b: null}


new Promise (resolve) ->
  # a.b.c()
  a 'はい'
.then ->
  console.log 'yo'
.catch (err) ->
  console.error err
  console.error err.stack

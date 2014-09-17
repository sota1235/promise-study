{Promise} = require 'es6-promise'
# Promise = require 'q'
# Promise = require 'bluebird'

checkOdd = (num) ->
  return new Promise (resolve) ->
    if typeof num isnt 'number'
      throw new Error "#{num} is not number"
    resolve num % 2 is 1

for i in [0,1,2,3,null,5,"かずどん",7,8]
  do (i) ->
    checkOdd i
    .then (res) ->
      if res
        console.log "#{i} is odd"
      else
        console.log "#{i} is not odd"
    .catch (err) ->
      console.error err

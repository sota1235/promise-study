# 関数の中にPromiseを入れた時のreturnの挙動を調べる

{Promise} = require 'es6-promise'

getNum = () ->
  return new Promise (resolve, reject) ->
    resolve 1

twice = (num) ->
  return new Promise (resolve, reject) ->
    resolve num * 2

main = () ->
  return new Promise (resolve, reject) ->
    getNum()
    .then twice
    .then twice
    .then (result) ->
      resolve result
    .catch (err) ->
      reject err

main()
.then (result) ->
  console.log result

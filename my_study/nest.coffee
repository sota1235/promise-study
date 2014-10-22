# 二重にPromiseした時どうなるか調べる

{Promise} = require 'es6-promise'

twice = (num) ->
  return new Promise (resolve, reject) ->
    resolve num * 2

printNum = (num) ->
  return new Promise (resolve, reject) ->
    console.log num.toString()
    resolve num

makeNumList = () ->
  return new Promise (resolve, reject) ->
    numList = []
    for i in [0..9]
      numList.push parseInt(Math.random() * 10 % 10)
    resolve numList

# main
NUM = 1

makeNumList()
.then (numList) ->
  promises = []
  for num in numList
    promises.push printNum num
  return promises
.then (promises) ->
  list = []
  Promise.all promises
  .then (num) ->
    console.log 'Promises: ' + num
    return num
  .catch (err) ->
    console.error
.then (list) ->
  console.log 'List: ' + list
.catch (err) ->
  console.error err

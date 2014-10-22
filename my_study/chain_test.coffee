# then()の仕様を確認する

{Promise} = require 'es6-promise'

twice = (num) ->
  return new Promise (resolve, reject) ->
    resolve num * 2

print_num = (num) ->
  return new Promise (resolve, reject) ->
    console.log num.toString()
    resolve num

# 関数と無名関数を交互にできるか否か
num = 1

twice 1
  .then print_num
  .then twice
  .then (result) ->
    console.log result
    return result
  .then twice
  .then (result) ->
    return result * 2
  .then print_num
  .catch (err) ->
    console.error err

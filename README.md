# Promise Study

いろいろなPromiseライブラリを使ってみる

- [es6-promise](https://www.npmjs.org/package/es6-promise)
- [q](https://github.com/petkaantonov/bluebird)
- [bluebird](https://github.com/kriskowal/q)


## Memo

### Qが例外をキャッチできない

- es6-promiseとbluebirdは混ぜてthen/catchでチェインさせても大丈夫
- qはcatchでエラーと取れない
- qの中でthrow Errorしてもcatchできなかった



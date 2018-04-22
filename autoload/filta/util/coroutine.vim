let s:Coroutine = vital#filta#import('Async.Coroutine')

function! filta#util#coroutine#start(...) abort
  let s:Coroutine.interval = g:filta#util#coroutine#interval
  return call(s:Coroutine.start, a:000, s:Coroutine)
endfunction


call filta#config#define(expand('<sfile>'), {
      \ 'interval': 30,
      \})

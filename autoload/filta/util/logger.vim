let s:Logger = vital#filta#import('Logger')

function! filta#util#logger#debug(...) abort
  return call('s:log', [0] + a:000)
endfunction

function! filta#util#logger#info(...) abort
  return call('s:log', [1] + a:000)
endfunction

function! filta#util#logger#warn(...) abort
  return call('s:log', [2] + a:000)
endfunction

function! filta#util#logger#error(...) abort
  return call('s:log', [3] + a:000)
endfunction


function! s:log(level, ...) abort
  let s:Logger.labels = ['DEBUG', 'INFO', 'WARN', 'ERROR']
  let s:Logger.filename = g:filta#util#logger#filename
  let s:Logger.threshold = g:filta#util#logger#threshold
  return call(s:Logger.log, [a:level] + a:000, s:Logger)
endfunction


call filta#config#define(expand('<sfile>'), {
      \ 'filename': expand('~/filta.log'),
      \ 'threshold': 0,
      \})

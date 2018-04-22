function! filta#context#new(source, ...) abort
  let context = extend({
        \ 'source': a:source,
        \ 'source_args': '',
        \ 'source_task': v:null,
        \ 'query': '',
        \ 'cursor': 1,
        \ 'items': [],
        \ 'indices': [],
        \ 'pattern': '',
        \ 'options': filta#context#options(),
        \}, a:0 ? a:1 : {},
        \)
  lockvar 1 context
  lockvar 2 context.source
  lockvar 3 context.options
  return context
endfunction

function! filta#context#actions(...) abort
endfunction

function! filta#context#options(...) abort
  let options = extend({
        \ 'prompt': '> ',
        \ 'height': 20,
        \ 'matcher': 'all',
        \ 'ignorecase': &ignorecase,
        \}, a:0 ? a:1 : {},
        \)
  lockvar 3 options
  return options
endfunction

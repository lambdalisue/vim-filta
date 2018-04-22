function! filta#start(source, ...) abort
  let context = filta#context#new(a:source, a:0 ? a:1 : {})
  call filta#source#start(
        \ context,
        \ funcref('s:source_receiver'),
        \ funcref('s:source_notifier'),
        \)
  call filta#window#open(context)
  call filta#window#update()
  call filta#filter#filter(funcref('s:filter_receiver'))
  call filta#filter#start(funcref('s:filter_receiver'))
endfunction


function! s:source_receiver(items) abort
  if !exists('b:context')
    return
  endif
  call filta#filter#filter(
        \ funcref('s:filter_receiver'),
        \)
endfunction

function! s:source_notifier(status) abort
  if !exists('b:context')
    return
  endif
  call filta#filter#filter(
        \ funcref('s:filter_receiver'),
        \)
endfunction

function! s:filter_receiver(context) abort
  " Update highlight
  if empty(a:context.pattern)
    silent nohlsearch
  else
    silent! execute printf(
          \ '/%s\%%(%s\)',
          \ a:context.options.ignorecase ? '\c' : '\C',
          \ a:context.pattern
          \)
  endif
  " Update content
  call filta#window#update()
  " Update statusline
  let &l:statusline = filta#statusline#create(a:context)
  " Update cursor and redraw
  call cursor(a:context.cursor, 1, 0)
  redraw
endfunction

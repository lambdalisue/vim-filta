function! filta#source#start(context, receiver, notifier) abort
  call filta#source#cancel(a:context)
  echomsg string(a:context)
  try
    let a:context.source_task = filta#source#{a:context.source}#start(
          \ a:context,
          \ funcref('s:receiver', [a:context, a:receiver]),
          \ a:notifier,
          \)
  catch /^Vim\%((\a\+)\)\=:E117/
    throw printf('filta: No source "%s" is found', a:context.source)
  endtry
endfunction

function! filta#source#cancel(context) abort
  if a:context.source_task isnot# v:null
    call a:context.source_task.cancel()
  endif
endfunction


function! s:receiver(context, receiver, items) abort
  if empty(a:items)
    return
  endif
  call extend(a:context.items, a:items)
  call a:receiver(a:items)
endfunction

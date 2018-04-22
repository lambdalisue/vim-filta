let s:RUNNING = 0
let s:CANCELLED = 1
let s:SUCCEEDED = 2
let s:FAILED = 3

function! s:_vital_created(module) abort
  let a:module.RUNNING = s:RUNNING
  let a:module.CANCELLED = s:CANCELLED
  let a:module.SUCCEEDED = s:SUCCEEDED
  let a:module.FAILED = s:FAILED
  let a:module.interval = 30
endfunction

function! s:start(coroutine, receiver, ...) abort dict
  let ns = {
        \ 'interval': self.interval,
        \ 'coroutine': a:coroutine,
        \ 'receiver': a:receiver,
        \ 'notifier': a:0 ? a:1 : v:null,
        \ 'status': s:RUNNING,
        \ 'timer': v:null,
        \}
  call s:_execute_coroutine(ns)
  let task = {
        \ 'status': { -> ns.status },
        \ 'cancel': funcref('s:_cancel_coroutine', [ns])
        \}
  lockvar 3 task
  return task
endfunction


function! s:_execute_coroutine(ns, ...) abort
  try
    if a:ns.coroutine(a:ns.receiver)
      let a:ns.timer = timer_start(
            \ a:ns.interval,
            \ funcref('s:_execute_coroutine', [a:ns]),
            \)
      return
    else
      let a:ns.timer = v:null
      let a:ns.status = s:SUCCEEDED
    endif
  catch
    let a:ns.timer = v:null
    let a:ns.status = s:FAILED
  endtry
  if a:ns.notifier isnot# v:null
    call a:ns.notifier(a:ns.status)
  endif
endfunction

function! s:_cancel_coroutine(ns) abort
  if a:ns.timer isnot# v:null
    silent! call timer_stop(a:ns.timer)
    let a:ns.timer = v:null
    let a:ns.status = s:CANCELLED
    if a:ns.notifier isnot# v:null
      call a:ns.notifier(a:ns.status)
    endif
  endif
endfunction

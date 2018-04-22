let s:Job = vital#filta#import('System.Job')


function! filta#source#grep#start(context, receiver, notifier) abort
  let ns = { 'stdout': [''], 'stderr': [''], 'status': 'running' }

  function! s:on_stdout(data) abort closure
    let ns.stdout[-1] .= a:data[0]
    call extend(ns.stdout, a:data[1:])

    if len(ns.stdout) > g:filta#source#grep#chunksize
      call a:receiver(map(
            \ remove(ns.stdout, 0, g:filta#source#grep#chunksize - 2),
            \ { _, v -> s:create_item(v) },
            \))
    endif
  endfunction

  function! s:on_stderr(data) abort closure
    let ns.stderr[-1] .= a:data[0]
    call extend(ns.stderr, a:data[1:])
  endfunction

  function! s:on_exit(exitstatus) abort closure
    if !empty(ns.stdout)
      call a:receiver(map(
            \ filter(ns.stdout, '!empty(v:val)'),
            \ { _, v -> s:create_item(v) }
            \))
    endif
    if !empty(ns.stderr)
      for line in ns.stderr
        call filta#util#logger#warn('grep: %s', line)
      endfor
    endif
    let ns.status = a:exitstatus ? 'failed' : 'succeeded'
    call a:notifier(ns.status)
  endfunction

  let args = empty(a:context.source_args)
        \ ? filta#util#prompt#input('grep arguments: ')
        \ : a:context.source_args
  let args = g:filta#source#grep#args . args
  let args = s:create_args(args)
  call filta#util#logger#debug('grep: "%s"', args)
  let job = s:Job.start(filta#util#string#split(args), {
        \ 'on_stdout': funcref('s:on_stdout'),
        \ 'on_stderr': funcref('s:on_stderr'),
        \ 'on_exit': funcref('s:on_exit'),
        \})
  return {
        \ 'name': 'grep',
        \ 'status': { -> ns.status },
        \ 'cancel': { -> job.stop() }
        \}
endfunction

function! s:create_item(text) abort
  let text = filta#util#string#remove_ansi_sequences(a:text)
  let item = {
        \ 'source': 'grep',
        \ 'text': text,
        \ 'abbr': a:text,
        \}
  lockvar 3 item
  return item
endfunction

function! s:create_args(args) abort
  if g:filta#source#grep#prog is# v:null
    let prog = &grepprg
    let prog = substitute(prog, '%', expand('%'), 'g')
    let prog = substitute(prog, '#', expand('#'), 'g')
    if stridx(prog, '$*') isnot# -1
      let prog = substitute(prog, '\$\*', a:args, 'g')
    else
      let prog = prog . ' ' . a:args
    endif
  else
      let prog = g:filta#source#grep#prog . ' ' . a:args
  endif
  return prog
endfunction


call filta#config#define(expand('<sfile>'), {
      \ 'prog': v:null,
      \ 'args': '--color=always ',
      \ 'chunksize': 1000,
      \})

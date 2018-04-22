function! filta#source#line#start(context, receiver, notifier) abort
  let ns = {
        \ 'bufnr': bufnr('%'),
        \ 'file': bufname('%'),
        \ 'step': g:filta#source#line#step,
        \ 'line': line('$'),
        \ 'cursor': 1,
        \}
  let task = filta#util#coroutine#start(
        \ funcref('s:coroutine', [ns]),
        \ a:receiver,
        \ a:notifier,
        \)
  return {
        \ 'name': 'line',
        \ 'status': task.status,
        \ 'cancel': task.cancel,
        \}
endfunction

function! s:coroutine(ns, yield) abort
  let c = a:ns.cursor
  let b = a:ns.bufnr
  let s = a:ns.step
  let f = a:ns.file
  let n = a:ns.line
  call a:yield(map(
        \ getbufline(b, c, c + s - 1),
        \ { k, v -> s:create_item(f, c + k, v) }
        \))
  let a:ns.cursor += s
  return a:ns.cursor <= n
endfunction

function! s:create_item(file, line, text) abort
  let text = filta#util#string#remove_ansi_sequences(a:text)
  let item = {
        \ 'source': 'line',
        \ 'text': text,
        \ 'abbr': a:line . ':' . a:text,
        \ '__source_file': a:file,
        \ '__source_line': a:line,
        \}
  lockvar 3 item
  return item
endfunction


call filta#config#define(expand('<sfile>'), {
      \ 'step': 1000,
      \})

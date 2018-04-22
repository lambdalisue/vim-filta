let s:HASH = sha256(expand('<sfile>:p'))
let s:STATUSLINE = join([
      \ '%%#FiltaStatuslineFile# %s ',
      \ '%%#FiltaStatuslineMiddle#%%=',
      \ '%%#FiltaStatuslineMatcher# Matcher: %s (C-^ to switch) ',
      \ '%%#FiltaStatuslineMatcher# Case: %s (C-_ to switch) ',
      \ '%%#FiltaStatuslineIndicator# %d/%d',
      \], '')

function! filta#filter#start(receiver) abort
  let context = b:context
  let timer = timer_start(
        \ 30,
        \ funcref('s:timer_callback', [a:receiver, context]),
        \ { 'repeat': -1 },
        \)
  " Define <Plug> mappings
  cnoremap <silent><buffer><expr> <Plug>(filta-prev-line) <SID>move_to_prev_line()
  cnoremap <silent><buffer><expr> <Plug>(filta-next-line) <SID>move_to_next_line()
  " Define custom mappings
  cmap <buffer> <C-t> <Plug>(filta-prev-line)
  cmap <buffer> <C-g> <Plug>(filta-next-line)
  try
    call filta#util#prompt#input(context.options.prompt)
    return 1
  catch /filta: CancelledError:/
    return
  finally
    call timer_stop(timer)
    cunmap <buffer> <Plug>(filta-prev-line)
    cunmap <buffer> <Plug>(filta-next-line)
    cunmap <buffer> <C-t>
    cunmap <buffer> <C-g>
  endtry
endfunction

function! filta#filter#filter(receiver) abort
  let context = b:context
  let query = context.query
  let items = context.items
  let matcher = context.options.matcher
  let ignorecase = context.options.ignorecase
  if empty(query)
    let pattern = ''
    let indices = range(0, len(items) - 1)
  else
    let pattern = filta#matcher#{matcher}#pattern(query, ignorecase)
    let indices = filta#matcher#{matcher}#indices(
          \ items,
          \ query,
          \ ignorecase,
          \)
  endif
  let context.cursor = max([min([context.cursor, len(indices)]), 1])
  if pattern !=# context.pattern || indices != context.indices
    let context.pattern = pattern
    let context.indices = indices
    call a:receiver(context)
  endif
endfunction


function! s:timer_callback(receiver, context, ...) abort
  let query = getcmdline()
  if query ==# a:context.query
    return
  endif
  let a:context.query = query
  call filta#filter#filter(a:receiver)
endfunction

function! s:move_to_prev_line() abort
  let context = b:context
  let size = max([len(context.indices), 1])
  let wrap = get(context.options, 'wrap_around', 1)
  if context.cursor is# 1
    let context.cursor = wrap ? size : 1
  else
    let context.cursor -= 1
  endif
  call cursor(context.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

function! s:move_to_next_line() abort
  let context = b:context
  let size = max([len(context.indices), 1])
  let wrap = get(context.options, 'wrap_around', 1)
  if context.cursor is# size
    let context.cursor = wrap ? 1 : size
  else
    let context.cursor += 1
  endif
  call cursor(context.cursor, 1, 0)
  redraw
  call feedkeys(" \<C-h>", 'n')   " Stay TERM cursor on cmdline
  return ''
endfunction

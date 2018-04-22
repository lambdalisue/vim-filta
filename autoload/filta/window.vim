let s:Writer = vital#filta#import('Vim.Buffer.Writer')


function! filta#window#open(context) abort
  let winnr = s:find_window()
  let height = a:context.options.height
  let bufname = 'filta://' . a:context.source

  if winnr is# -1
    execute printf('botright %dnew %s', height, bufname)
  else
    execute printf('%dwincmd w | enew', winnr)
    execute printf('silent! file %s', bufname)
    execute printf('resize %d', height)
  endif

  setlocal buftype=nofile bufhidden=wipe
  setlocal nonumber norelativenumber
  setlocal nofoldenable nocursorcolumn
  setlocal nomodifiable
  setlocal cursorline
  setlocal filetype=filta

  unlockvar 1 a:context
  let a:context.bufnr = bufnr('%')
  let a:context.winid = win_getid()
  lockvar 1 a:context
  lockvar 2 a:context.bufnr
  lockvar 2 a:context.winid

  let b:context = a:context
endfunction

function! filta#window#update() abort
  let context = b:context
  if get(context, 'bufnr', v:null) is# v:null
    return
  endif
  let bufnr = context.bufnr
  let items = context.items
  let indices = context.indices
  let content = map(
        \ copy(indices[: 1000]),
        \ { _, v -> get(items[v], 'abbr', items[v].text) }
        \)
  call s:Writer.replace(bufnr, 0, -1, content)
  call setbufvar(bufnr, '&modified', 0)
endfunction


function! s:find_window() abort
  for nr in range(winnr('$'))
    if bufname(winbufnr(nr)) =~# '^filta://'
      return nr
    endif
  endfor
  return -1
endfunction

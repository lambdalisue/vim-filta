function! filta#action#open#complete(arglead, cmdline, cursorpos) abort
  let openers = [
        \ 'edit',
        \ 'split',
        \ 'vsplit',
        \]
  return filter(openers, { _, v -> v =~# '^' . a:arglead })
endfunction

function! filta#action#open#call(items, ...) abort
  let opener = a:0 ? a:1 : 'edit'
  for item in a:items
    let f = item.__source_file
    let l = get(item, '__source_line', 1)
    let c = get(item, '__source_col', 1)
    execute printf(
          \ '%s %s +call\ cursor(%d, %d)',
          \ opener,
          \ f, l, c,
          \)
  endfor
endfunction

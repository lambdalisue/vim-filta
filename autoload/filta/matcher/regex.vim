function! filta#matcher#regex#pattern(query, ignorecase) abort
  return a:query
endfunction

function! filta#matcher#regex#indices(items, query, ignorecase) abort
  if len(a:items) is# 0
    return []
  endif
  let pattern = (a:ignorecase ? '\c' : '\C') . a:query
  let indices = range(0, len(a:items) - 1)
  return filter(
        \ indices,
        \ { _, v -> a:items[v].text =~# pattern }
        \)
endfunction

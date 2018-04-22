function! filta#matcher#fuzzy#pattern(query, ignorecase) abort
  let chars = map(
        \ split(a:ignorecase ? tolower(a:query) : a:query, '\zs'),
        \ 'filta#util#string#escape_pattern(v:val)'
        \)
  let patterns = map(chars, { _, v -> printf('%s[^%s]\{-}', v, v)})
  return join(patterns, '')
endfunction

function! filta#matcher#fuzzy#indices(items, query, ignorecase) abort
  if len(a:items) is# 0
    return []
  endif
  let pattern = (a:ignorecase ? '\c' : '\C') . filta#matcher#fuzzy#pattern(a:query, a:ignorecase)
  let indices = range(0, len(a:items) - 1)
  return filter(
        \ indices,
        \ { _, v -> a:items[v].text =~# pattern }
        \)
endfunction

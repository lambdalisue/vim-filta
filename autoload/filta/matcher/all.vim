function! filta#matcher#all#pattern(query, ignorecase) abort
  if a:ignorecase
    return join(map(split(tolower(a:query), ' '), 'filta#util#string#escape_pattern(v:val)'), '\|')
  else
    return join(map(split(a:query, ' '), 'filta#util#string#escape_pattern(v:val)'), '\|')
  endif
endfunction

function! filta#matcher#all#indices(items, query, ignorecase) abort
  if len(a:items) is# 0
    return []
  endif
  let indices = range(0, len(a:items) - 1)
  let query = a:ignorecase ? tolower(a:query) : a:query
  let Wrap = a:ignorecase ? function('tolower') : { v -> v }
  for term in split(query, ' ')
    call filter(
          \ indices,
          \ { _, v -> stridx(Wrap(a:items[v].text), term) isnot# -1 },
          \)
  endfor
  return indices
endfunction

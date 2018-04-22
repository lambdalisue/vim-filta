function! filta#util#string#remove_ansi_sequences(text) abort
  return substitute(a:text, '\e\[\%(\%(\d\+;\)*\d\+\)\?[mK]', '', 'g')
endfunction

function! filta#util#string#escape_pattern(text) abort
  return escape(a:text, '^$~.*[]\')
endfunction

function! filta#util#string#split(cmdline) abort
  if exists('s:parse_pattern')
    return map(
          \ split(a:cmdline, s:parse_pattern),
          \ 's:norm_term(v:val)',
          \)
  endif

  let single_quote = '''\zs[^'']\+\ze'''
  let double_quote = '"\zs[^"]\+\ze"'
  let bare_strings = '\%(\\\s\|[^ ''"]\)\+'
  let s:parse_pattern = printf(
        \ '\%%(%s\)*\zs\%%(\s\+\|$\)\ze',
        \ join([single_quote, double_quote, bare_strings], '\|')
        \)
        \
  function! s:norm_term(term) abort
    let pattern = '^\%("\zs.*\ze"\|''\zs.*\ze''\|.*\)$'
    let m = matchlist(a:term, '^\(-\w\|--\S\+=\)\(.\+\)')
    if empty(m)
      return matchstr(a:term, pattern)
    endif
    return m[1] . matchstr(m[2], pattern)
  endfunction

  return filta#util#string#split(a:cmdline)
endfunction

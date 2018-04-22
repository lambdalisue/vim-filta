let s:STATUSLINE = join([
      \ '%%#FiltaStatuslineFile# %s ',
      \ '%%#FiltaStatuslineMiddle#%%=',
      \ '%%#FiltaStatuslineMatcher# Matcher: %s (C-^ to switch) ',
      \ '%%#FiltaStatuslineMatcher# Case: %s (C-_ to switch) ',
      \ '%%#FiltaStatuslineIndicator# %d/%d',
      \], '')


function! filta#statusline#create(context) abort
  return printf(
        \ s:STATUSLINE,
        \ expand('%'),
        \ a:context.options.matcher,
        \ a:context.options.ignorecase ? 'ignore' : 'normal',
        \ min([1000, len(a:context.indices)]),
        \ len(a:context.items),
        \)
endfunction

let s:HASH = sha256(expand('<sfile>:p'))
let s:t_string = type('')
let s:t_func = type(function('tr'))


function! filta#util#prompt#warn(message, ...) abort
  try
    echohl WarningMsg
    echo 'filta: ' . (a:0 ? call('printf', [a:message] + a:000) : a:message)
  finally
    echohl None
  endtry
endfunction

function! filta#util#prompt#input(prompt, ...) abort
  let args = a:0 > 1
        \ ? [a:1, s:ensure_completion(a:2)]
        \ : [a:0 ? a:1 : '']
  echohl Question
  execute printf(
        \ 'cnoremap <buffer><silent> %s <C-u>%s<CR>',
        \ '<Plug>(filta-prompt-cancel)',
        \ s:HASH,
        \)
  cmap <buffer> <Esc> <Plug>(filta-prompt-cancel)
  cmap <buffer> <C-]> <Plug>(filta-prompt-cancel)
  call inputsave()
  try
    let r = call('input', [a:prompt] + args)
    if r ==# s:HASH
      throw 'filta: CancelledError: input has cancelled by user'
    endif
    return r
  finally
    call inputrestore()
    silent cunmap <buffer> <Plug>(filta-prompt-cancel)
    silent cunmap <buffer> <Esc>
    silent cunmap <buffer> <C-]>
    echohl None
  endtry
endfunction


function! s:ensure_completion(completion) abort
  if type(a:completion) is# s:t_string
    return a:completion
  elseif type(a:completion) is# s:t_func
    return 'customlist,' . get(a:completion, 'name')
  else
    throw printf(
          \ 'filta: Unknown completion type "%s" has specified',
          \ type(a:completion),
          \)
  endif
endfunction

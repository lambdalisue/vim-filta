function! s:_vital_created(module) abort
  let a:module.labels = []
  let a:module.filename = ''
  let a:module.threshold = 2
endfunction

function! s:start(filename) abort dict
  let parent = fnamemodify(a:filename, ':p:h')
  if !isdirectory(parent)
    call mkdir(parent, 'p')
  endif
  let self.filename = fnamemodify(a:filename, ':p')
endfunction

function! s:stop() abort dict
  let self.filename = ''
endfunction


function! s:log(level, message, ...) abort dict
  if empty(self.filename)
    return
  elseif self.threshold > a:level
    return
  endif
  let message = a:0 ? call('printf', [a:message] + a:000) : a:message
  let record = printf(
        \ "%s\t%s\t%s",
        \ strftime('%H%M%S'),
        \ get(self.labels, a:level, a:level),
        \ message,
        \)
  call timer_start(0, { -> writefile([record], self.filename, 'a') })
endfunction

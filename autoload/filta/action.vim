function! filta#action#call(name, ...) abort
  let name = a:name
  let name = substitute(name, '/', '#', 'g')
  let name = substitute(name, '\W', '_', 'g')
  call call(printf('filta#action#%s#call', name), a:000)
endfunction

function! filta#action#complete(name, ...) abort
  let name = a:name
  let name = substitute(name, '/', '#', 'g')
  let name = substitute(name, '\W', '_', 'g')
  call call(printf('filta#action#%s#complete', name), a:000)
endfunction

function! filta#action#start(context) abort
  let context = filta#context#new({
        \ 'source': 'action',
        \ 'actions': {},
        \ 'options': filta#context#options({
        \   'prompt': 'action: ',
        \ }),
        \ '__source_actions': a:context.actions,
        \ '__source_context': a:context,
        \})
  try
    let r = filta#start(context)
  finally
    call filta#start(a:context)
  endtry
endfunction

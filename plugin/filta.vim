if exists('g:loaded_filta')
  finish
endif
let g:loaded_filta = 1

command! -nargs=+ -range=% -bang
      \ -complete=customlist,filta#command#complete
      \ Filta
      \ call filta#command#call(<q-bang>, <q-mods>, <q-args>, [<line1>, <line2>])

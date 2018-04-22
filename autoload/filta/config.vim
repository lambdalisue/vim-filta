let s:Config = vital#filta#import('Config')


function! filta#config#define(...) abort
  call call(s:Config.config, a:000, s:Config)
endfunction

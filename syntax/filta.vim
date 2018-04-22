if exists('b:current_syntax')
  finish
endif
let b:current_syntax = 'XXXXX'
let s:save_cpoptions = &cpoptions
set cpoptions&vim

syntax clear

let s:ANSI = vital#filta#import('Vim.Buffer.ANSI')
call s:ANSI.define_syntax()

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions

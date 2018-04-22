let s:Path = vital#filta#import('System.Filepath')


function! filta#util#module#findall(category) abort
  let runtimes = map(
        \ split(&runtimepath, ','),
        \ 'expand(v:val)',
        \)
  let candidates = []
  for runtime in runtimes
    let root = s:Path.realpath(printf(
          \ '%s/autoload/filta/%s',
          \ runtime,
          \ a:category,
          \))
    let expr = s:Path.join(root, '**', '*.vim')
    call extend(candidates, map(
          \ glob(expr, 1, 1, 1),
          \ 's:get_name(v:val, root)',
          \))
  endfor
  return uniq(candidates)
endfunction


function! s:get_name(path, root) abort
  return fnamemodify(a:path, printf(':s?%s[/\\]??:r', a:root))
endfunction

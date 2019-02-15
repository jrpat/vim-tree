let s:default_cmd   = 'tree -c -F --dirsfirst --noreport'
let s:default_chars = '[^│─├└  ]'

function! tree#Tree(options) abort
  enew
  execute 'silent %!'.get(g:, 'tree_cmd', s:default_cmd).' '.a:options
  setlocal nomodified buftype=nofile bufhidden=wipe
  let &l:statusline = ' tree '.getcwd()
  nnoremap q :silent bwipeout<cr>
  augroup tree
    autocmd!
    autocmd CursorMoved <buffer> call s:on_cursormoved()
  augroup END
  set filetype=tree
endfunction

function! s:get_name(...) abort
  if a:0
    let line = getline(a:1)[a:2:]
  else
    let line = getline('.')[col('.')-1:]
  endif
  return matchstr(line, '.*')
endfunction

function! tree#GetPath() abort
  let path = ''
  let [line, col] = [line('.'), col('.')]
  while line > 1
    let cur_col = match(getline(line), s:default_chars)
    if cur_col < col
      let col = cur_col
      let path = s:get_name(line, col) . path
    endif
    let line -= 1
  endwhile
  return path
endfunction

function! s:on_cursormoved() abort
  normal! 0
  call search(s:default_chars, '', line('.'))
endfunction
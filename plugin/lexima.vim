let s:save_cpo = &cpo
set cpo&vim

if exists('g:loaded_lexima')
  finish
endif
let g:loaded_lexima = 1

call lexima#init()


if !exists('g:lexima_map_escape')
  let g:lexima_map_escape = '<Esc>'
endif

" Setup workaround to be able to map `Esc` in insert mode, in combination with
" the "nowait" mapping. This is required in terminal mode, where escape codes
" are being used for cursor keys, alt/meta mappings etc.
if g:lexima_map_escape == '<Esc>' && !has('gui_running')
  inoremap <unique> <Esc><Esc> <Esc>
endif

function! s:setup_insmode()
  if g:lexima_map_escape == ''
    return
  endif
  if v:version > 703 || (v:version == 703 && has("patch1261"))
    exe 'inoremap <buffer> <silent> <nowait> '.g:lexima_map_escape.' <C-r>=lexima#insmode#escape()<CR><Esc>'
  else
    exe 'inoremap <buffer> <silent> '.g:lexima_map_escape.' <C-r>=lexima#insmode#escape()<CR><Esc>'
  endif
endfun

augroup lexima
  autocmd!
  autocmd InsertEnter * call lexima#insmode#clear_stack()
  autocmd InsertEnter * call s:setup_insmode()
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo

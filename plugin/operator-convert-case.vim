"=============================================================================
" File: plugin/operator-convert-case.vim
" Author: mopp
" Created: 2017-12-04
"=============================================================================

scriptencoding utf-8

if exists('g:loaded_operator_convert_case')
    finish
endif
let g:loaded_operator_convert_case = 1

let s:save_cpo = &cpo
set cpo&vim


function! ConvertCaseCustomList(arg_lead, cmd_line, cursor_pos) abort
    return ['lower_snake_case', 'UPPER_SNAKE_CASE', 'lowerCamelCase', 'UpperCamelCase']
endfunction


function! s:map_toggle_upper_lower() abort
    :ToggleUpperLower

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-toggle-upper-lower)")
    endif
endfunction


let s:last_used_case = ''
function! s:map_convert() abort
    call inputsave()

    let s:last_used_case = input('target case: ', '', 'customlist,ConvertCaseCustomList')

    call operator#convert_case#convert(expand('<cword>'), s:last_used_case)

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-dummy)")
    endif

    call inputrestore()
endfunction


function! s:map_dummy() abort
    call operator#convert_case#convert(expand('<cword>'), s:last_used_case)

    if exists('*repeat')
        call repeat#set("\<Plug>(operator-convert-dummy)")
    endif
endfunction


command! -nargs=0 ConvertTest call operator#convert_case#test()
command! -nargs=0 ToggleUpperLower call operator#convert_case#toggle_upper_lower(expand('<cword>'))
command! -nargs=1 -complete=customlist,ConvertCaseCustomList ConvertCase call operator#convert_case#convert(expand('<cword>'), <f-args>)

nnoremap <script> <Plug>(operator-convert-dummy) :<C-U>call <SID>map_dummy()<CR>
nnoremap <script> <Plug>(operator-convert-convert) :<C-U>call <SID>map_convert()<CR>
nnoremap <script> <Plug>(operator-convert-toggle-upper-lower) :<C-U>call <SID>map_toggle_upper_lower()<CR>


let &cpo = s:save_cpo
unlet s:save_cpo

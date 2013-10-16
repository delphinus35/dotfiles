"-----------------------------------------------------------------------------
" 時刻表示形式 → (月) 01/02 午後 03:45
let g:unite_source_file_mru_time_format='(%a) %m/%d %p %I:%M '
" プロンプト
let g:unite_prompt=' '
" 挿入モードで開a
let g:unite_enable_start_insert=1
" ステータスラインを書き換えない
let g:unite_force_overwrite_statusline=0

" unite-qfixhowm 対応
" 更新日時でソート
call unite#custom_source('qfixhowm', 'sorters', ['sorter_qfixhowm_updatetime', 'sorter_reverse'])
" デフォルトアクション
let g:unite_qfixhowm_new_memo_cmd='dwm_new'

" データファイル
if is_office
    let g:unite_data_directory = expand('$H/.unite')
endif
noremap zp :Unite buffer_tab file_mru<CR>
noremap zn :UniteWithBufferDir -buffer-name=files file file/new<CR>
noremap zd :Unite dwm<CR>
noremap zf :Unite qfixhowm/new qfixhowm<CR>
noremap zF :Unite qfixhowm/new qfixhowm:nocache<CR>
noremap zi :Unite tig<CR>
noremap <Leader>uu :Unite bookmark<CR>
noremap <Leader>uc :Unite colorscheme<CR>
noremap <Leader>ul :Unite locate<CR>
noremap <Leader>uv :Unite buffer -input=vimshell<CR>
noremap <Leader>vu :Unite buffer -input=vimshell<CR>
autocmd FileType unite call s:unite_my_settings()
call unite#custom#substitute('files', '\$\w\+', '\=eval(submatch(0))', 200)
call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/"', 2)
call unite#custom#substitute('files', '^@', '\=getcwd()."/*"', 1)
call unite#custom#substitute('files', '^;r', '\=$VIMRUNTIME."/"')
call unite#custom#substitute('files', '^\~', escape($HOME, '\'), -2)
call unite#custom#substitute('files', '\\\@<! ', '\\ ', -20)
call unite#custom#substitute('files', '\\ \@!', '/', -30)
if is_office
    call unite#custom#substitute('files', '^;h', '\=$H."/"')
    call unite#custom#substitute('files', '^;v', '\=$H."/.vim/"')
    call unite#custom#substitute('files', '^;g', '\=$H."/git/"')
    call unite#custom#substitute('files', '^;d', '\=$H."/git/dotfiles/"')
else
    call unite#custom#substitute('files', '^;v', '~/.vim/')
    call unite#custom#substitute('files', '^;g', escape($HOME, '\') . '/git/')
    call unite#custom#substitute('files', '^;d', escape($HOME, '\') . '/git/dotfiles/')
endif
if has('win32') || has('win64')
  call unite#custom#substitute('files', '^;p', 'C:/Program Files/')
  call unite#custom#substitute('files', '^;u', escape($USERPROFILE, '\') . '/')
endif

" vcscommand.vim の diff buffer を消す
call unite#custom_filters('buffer,buffer_tab',
            \ ['matcher_default', 'sorter_default', 'converter_erase_diff_buffer'])

function! s:unite_my_settings()
    " 上下に分割して開く
    nnoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    inoremap <silent> <buffer> <expr> <C-J> unite#do_action('split')
    " 左右に分割して開く
    nnoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    inoremap <silent> <buffer> <expr> <C-K> unite#do_action('vsplit')
    " タブで開く
    nnoremap <silent> <buffer> <expr> <C-T> unite#do_action('tabopen')
    inoremap <silent> <buffer> <expr> <C-T> unite#do_action('tabopen')
    " vimfiler で開く
    nnoremap <silent> <buffer> <expr> <C-O> unite#do_action('vimfiler')
    inoremap <silent> <buffer> <expr> <C-O> unite#do_action('vimfiler')
    " dwm.vim で開く
    nnoremap <silent> <buffer> <expr> <C-N> unite#do_action('dwm_new')
    inoremap <silent> <buffer> <expr> <C-N> unite#do_action('dwm_new')
    " rec/async で開く
    nnoremap <silent> <buffer> <expr> <C-F> unite#do_action('rec/async')
    inoremap <silent> <buffer> <expr> <C-F> unite#do_action('rec/async')
    " 終了
    nmap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    imap <silent> <buffer> <ESC><ESC> <Plug>(unite_exit)
    " インサートモードで上下移動
	" <F15> => <M-p>, <F17> => <M-n>
    imap <silent> <buffer> <F15> <Plug>(unite_select_previous_line)
    imap <silent> <buffer> <F17> <Plug>(unite_select_next_line)
    " ノーマルモードでソース選択
    nmap <silent> <buffer> <M-p> <Plug>(unite_rotate_previous_source)
    nmap <silent> <buffer> <M-n> <Plug>(unite_rotate_next_source)
    " 一つ上のパスへ
    imap <buffer> <C-W> <Plug>(unite_delete_backward_path)
endfunction

" agとUnite.vimで快適高速grep環境を手に入れる - Thinking-megane
" http://blog.monochromegane.com/blog/2013/09/18/ag-and-unite/
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" grep検索
nnoremap zg :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap zu :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap zG :<C-u>UniteResume search-buffer<CR>

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '-a --nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

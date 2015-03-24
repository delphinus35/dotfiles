" 使う文字
let g:EasyMotion_keys = 'hjklasdfgyuiopqwertnmzxcvbHJKLASDFGYUIOPQWERTNMZXCVB'
" 1 ストローク選択を優先する
let g:EasyMotion_grouping =1
" 日本語検索
let g:EasyMotion_use_migemo = 1
" Space か Enter を押すと最初のマッチに飛ぶ
let g:EasyMotion_enter_jump_first = 1
let g:EasyMotion_space_jump_first = 1

" Leader に ' を設定
map ' <Plug>(easymotion-prefix)

nmap s <Plug>(easymotion-s)
xmap s <Plug>(easymotion-s)
omap s <Plug>(easymotion-s)
nmap S <Plug>(easymotion-s2)
xmap S <Plug>(easymotion-s2)
omap S <Plug>(easymotion-s2)
map  '/ <Plug>(easymotion-sn)
omap '/ <Plug>(easymotion-tn)
map  'n <Plug>(easymotion-next)
map  'N <Plug>(easymotion-prev)

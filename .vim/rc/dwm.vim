nnoremap <C-J> <C-W>w
nnoremap <C-K> <C-W>W
nmap <C-T> <Plug>DWMRotateClockwise
nmap <C-Q> <Plug>DWMRotateCounterclockwise
nmap <C-N> <Plug>DWMNew
nmap <C-C> <Plug>DWMClose
nmap <C-@> <Plug>DWMFocus
nmap <C-Space> <Plug>DWMFocus
nmap <C-L> <Plug>DWMGrowMaster
nmap <C-H> <Plug>DWMShrinkMaster
nmap <BS>  <Plug>DWMShrinkMaster

command! DWMSetMasterPaneWidth call delphinus#dwm#set_master_pane_width()
command! DWMDisable call delphinus#dwm#disable()
command! DWMEnable call delphinus#dwm#enable()

scriptencoding utf-8

" Encodings {{{
set fileencoding=utf-8
if !has('gui_macvim')
  set fileencodings=ucs-bom,utf-8,eucjp,cp932,ucs-2le,latin1,iso-2022-jp
endif
" }}}

" Tabs {{{
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2
" }}}

" Directories {{{
set backupcopy=auto
set backupdir^=~/.local/share/nvim/backup//
" needed for editing crontab in macOS
set backupskip^=/private/tmp/*
" Use dir for Neovim's default
set directory^=~/.local/share/nvim/swap//
set nobackup
set swapfile
" Use dir for Neovim's default
set undodir^=~/.local/share/nvim/undo//
set undofile
set writebackup
" }}}

" Searching {{{
set ignorecase
set smartcase
if exists('+inccommand')
  set inccommand=split
endif
" }}}

" Display {{{
set ambiwidth=single
set cmdheight=2
set colorcolumn=80,140
set list
set listchars=tab:░\ ,trail:↔,eol:⏎,extends:→,precedes:←,nbsp:␣
set noruler
set noshowmode
set number
set numberwidth=3
set relativenumber
set showmatch
set showtabline=1
" }}}

" Indents and arranging formats {{{
set breakindent
set formatoptions+=nmMj
" Detect sequence numbers with parentheses
set formatlistpat=^\\s*\\%(\\d\\+\\\|[-a-z]\\)\\%(\\\ -\\\|[]:.)}\\t]\\)\\?\\s\\+
set nofixendofline
set showbreak=→\  
set smartindent
set wrap
" }}}

" Mouse {{{
set mouse=a
" }}}

" Colorschemes {{{
set termguicolors
syntax enable

function! s:toggle_colorscheme() abort
  if &background ==# 'light'
    set background=dark
    colorscheme nord
  elseif &background ==# 'dark'
    set background=light
    colorscheme solarized8
  endif
endfunction

command! ToggleColorscheme call <SID>toggle_colorscheme()

" Use Solarized Light when iTerm2 reports 11;15 for $COLORFGBG
let g:bg_light = $COLORFGBG ==# '11;15'
if g:bg_light
  set background=light
endif
let g:use_solarized = g:bg_light || $SOLARIZED
if g:use_solarized
  colorscheme solarized8
else
  colorscheme nord
endif
" }}}

" Title {{{
if exists('$TMUX')
  set t_ts=k
  set t_fs=\
endif

set title
" }}}

" その他 {{{
set completeopt+=menuone
set completeopt-=preview
set diffopt=internal,filler,vertical,iwhite,algorithm:patience
set fileformat=unix
set fileformats=unix,dos
set grepprg=pt\ --nogroup\ --nocolor
set guicursor=n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50
      \,a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor
      \,sm:block-blinkwait175-blinkoff150-blinkon175
set helplang=ja
set lazyredraw
set matchpairs+=（:）,「:」,【:】,［:］,｛:｝,＜:＞
set scrolloff=3
set sidescrolloff=5
set synmaxcol=0
set virtualedit=block
set wildmode=full
" }}}

" Neovim specific settings {{{
if has('nvim')
  if has('nvim-0.5')
    set fillchars=diff:░,eob:‣,fold:░,foldopen:▾,foldsep:│,foldclose:▸
  else
    set fillchars=diff:░,eob:‣,fold:░
  endif
  set pumblend=30  " transparency
  set shada=!,'1000,<50,s10,h  " Store 1000 entries on oldfiles
  if exists('$TMUX')
    let g:clipboard = {
          \ 'name': 'tmux-clipboard',
          \ 'copy': {
          \   '*': 'tmux load-buffer -',
          \ },
          \ 'paste': {
          \   '*': 'tmux save-buffer -',
          \ }}
  endif
else
  set autoindent
  set backspace=indent,eol,start
  set clipboard=autoselectml
  set fillchars=diff:░,fold:\ ,vert:│
  set history=10000
  set hlsearch
  set incsearch
  set laststatus=2
  set nrformats=bin,hex
  set pyxversion=3
  set shortmess+=c  " for echodoc
  set showcmd
  set sidescroll=1
  set smarttab
  set ttyfast
  set ttymouse=sgr
  set viminfo='1000,<50,s10,h
  set wildmenu
endif
" }}}

" vim:se fdm=marker:

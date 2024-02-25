filetype indent on
syntax on "コード色分け
let mapleader="\<Space>"

"###表示設定###
set number "行番号
set title "編集中のファイル名
set showmatch "括弧入力時の対応する括弧を表示
set showcmd "コマンドを画面の再下行に表示
set background=dark
set tabstop=4 "インデントのスペースを4に
set expandtab
set smartindent "オートインデント
set laststatus=2
set ruler "カーソルの行列目を表示（ルーラー）
set history=200 "command history

set backspace=indent,eol,start "バックスペースの対象の設定

"###検索設定###
set hlsearch
set incsearch "インクリメンタルサーチ
set ignorecase "大文字/小文字の区別なく検索
set smartcase "検索文字列に大文字が含まれている場合は区別して検索
set wrapscan "検索時に最後まで行ったら最初に戻る

"###キーマップ###
" vim のキーバインドに慣れるために無効化。また、VSCodeの機能と干渉する
" inoremap <C-b> <Left>
" inoremap <C-n> <Down>
" inoremap <C-p> <Up>
" inoremap <C-f> <Right>
inoremap jk <ESC>
inoremap <C-a> <ESC>0i
inoremap <C-e> <ESC>$a

nnoremap k gk
nnoremap gk k
nnoremap j gj
nnoremap gj j
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
"# ハイライトを消す
nnoremap <Esc><Esc> :nohlsearch<CR><Esc>
noremap <C-j> 5j
noremap <C-k> 5k

"コマンド履歴を呼び出すキーバインド
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

"バッファの移動
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

"# 削除、カットの設定
"## d, sはブラックホールレジスタを使用する
"## c, xはそのまま無名レジスタを使用
" yankレジスタを指定することで上書き問題は解決できそう "0p でペーストすれば良い
" nnoremap d "_d
" nnoremap D "_D
" xnoremap d "_d
" nnoremap s "_s
" nnoremap S "_S

"###クリップボード連結###
set clipboard=unnamed

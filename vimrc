" URL: 
" Author: mi
" Description: Personal .vimrc file
"
" All the plugins are managed via vim-plug, run :PlugInstall to install all
" the plugins from Github, :PlugUpdate to update. Leader key is the spacebar.


" 1: general settings {{{1

" basics {{{2
syntax on                       " シンタックスハイライトをオン
set nocompatible                " not compatible to Vi
set backspace=start,eol,indent  " 
set whichwrap=b,s,[,],<,>,~     " 
set mouse=
" let mapleader = "\<space>"      " leaderキーをspaceに変更 *1 p122
let mapleader = ','             " leaderキーをカンマに変更 *1 p122

" search {{{2
set incsearch                   " インクリメンタルサーチ
set hlsearch                    " 検索時にハイライト
set ignorecase                  " 検索時大文字小文字を無視
set nowrapscan                  " ファイル末まで検索後、頭に戻らない

set showcmd                     " 入力中のコマンドを表示
set wildmenu                    " タブによる自動補完を有効化
set wildmode=list:longest,full  " 最長マッチまで補完し自動補完メニューを開く

" edit {{{2
filetype plugin indent on       " ファイルタイプに基づいたインデントを有効化
set tabstop=4                   " タブ幅を4に
set expandtab                   " タブをスペースに変換
set shiftwidth=4                " インデントに使われるスペースの数
set autoindent                  " 新しい行を始めるときに自動でインデント
set smartindent                 " smart indent
set ambiwidth=double
set clipboard=unnamed,unnamedplus   " Use system clipboard

" fold {{{2
set foldmethod=indent           " 折りたたみ設定 *1 p65/68
set foldlevel=99                " なるべく折りたたみを開く
set foldcolumn=3                " 折りたたみ状態表示カラム数

" appearance {{{2
set number                      " 行番号表示
set laststatus=2                " ステータス行を常に表示
set list                        " 不可視文字の表示
set listchars=tab:»-,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set scrolloff=5                 " 最低でも表示する行数
set cursorline                  " Highlight cursor line

set t_Co=256
set termguicolors

" others {{{2
set nrformats-=octal            " <C-a/x>で8進数とはみなさない
set hidden
set history=2000                " 履歴を2000件持つようにする
set virtualedit=block

" }}}


" 2: plugin: using vim-plug {{{1

call plug#begin()

Plug 'tpope/vim-unimpaired'     " useful mappings
Plug 'Lokaltog/vim-easymotion'  " better move commands
Plug 'ctrlpvim/ctrlp.vim'       " あいまい検索
Plug 'itchyny/lightline.vim'    " custom statusline
Plug 'vim-jp/vimdoc-ja'         " help in Japanese
Plug 'sjl/gundo.vim'            " visualize the undo tree
" Plug 'glidenote/memolist.vim'   " take memos quickly
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'https://github.com/alok/notational-fzf-vim'
                                " fzf and notational-fzf
Plug 'tpope/vim-fugitive'       " git on vim

Plug 'morhetz/gruvbox'          " color scheme
Plug 'arcticicestudio/nord-vim' " color scheme
Plug 'micke/vim-hybrid'         " color scheme
" Plug 'jacoborus/tender.vim'     " color scheme
" Plug 'cocopon/iceberg.vim'      " color scheme

call plug#end()

" }}}


" 3: user specific {{{1

" key remap {{{2

" disable arrow keys
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" disable ZZ
nnoremap ZZ <Nop>

" カーソルを表示行で移動
nnoremap j gj
nnoremap k gk

" h/lで行頭/行末を超えられる｀
nnoremap h <Left>
nnoremap l <Right>

" swap ; and : *4
nnoremap ; :
vnoremap ; :
nnoremap q; q:
vnoremap q; q:
nnoremap : ;
vnoremap : ;

nnoremap Y y$                   " YをDなどと同じ感じに
nnoremap <Leader>w :w<CR>       " 保存ショートカット

nnoremap <Esc><Esc> :noh<CR><Esc> " ハイライトを消す

" moving with spacebar
nnoremap <Space>h 0
nnoremap <Space>l $
nnoremap <Space><Space> <C-d>zz
nnoremap <S-Space> <C-u>zz

" insert mode / emacs like
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <C-a> <C-o>^
inoremap <C-e> <C-o>$
inoremap <C-h> <BS>
inoremap <C-d> <Del>

" c-p/nを使えるが、自動補完が効かなくなっているので注意 *5
inoremap <silent> <expr> <C-p>  pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
inoremap <silent> <expr> <C-n>  pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"

""""""""""""""""""""""""""""""
"IMEの状態とカーソル位置保存のため<C-r>を使用してコマンドを実行 *5
""""""""""""""""""""""""""""""
function! MyExecExCommand(cmd, ...)
  let saved_ve = &virtualedit
  let index = 1
  while index <= a:0
    if a:{index} == 'onemore'
      silent setlocal virtualedit+=onemore
    endif
    let index = index + 1
  endwhile

  silent exec a:cmd
  if a:0 > 0
    silent exec 'setlocal virtualedit='.saved_ve
  endif
  return ''
endfunction


" swapファイルをひとつのところにまとめる (*1 p31)
set directory=$HOME/.vim/swap//

" undo {{{2
" すべてのファイルで永続アンドゥ (*1 p39)
set undofile
set undodir=$HOME/.vim/undodir


" current file directry {{{2
" set current file directory *4
augroup movecurrentdir
  autocmd!
  autocmd BufRead,BufEnter * if isdirectory(expand('%:p:h')) | lcd %:p:h | endif
augroup END


" vimrc関係 *4 {{{2

" 現在のバッファが空っぽならば :drop それ以外なら :tab drop になるコマンド
function! SmartDrop(tabedit_args)
  if expand('%') == "" && !&modified
    let drop_cmd = "drop "
  else
    let drop_cmd = "tab drop "
  endif
  silent execute drop_cmd . a:tabedit_args
endfunction
command! -nargs=* SmartDrop call SmartDrop(<q-args>)

" vimrcを開くショートカット
nnoremap <silent> <Leader>v :<C-u>SmartDrop ~/.vim/vimrc<CR>
nnoremap <silent> <Leader>gv :<C-u>SmartDrop ~/.vim/gvimrc<CR>


" 4: plugin specific {{{1

" GundoToggle {{{3
noremap <Leader>gu :GundoToggle<cr>

" カラースキーム {{{2

" hybrid colorscheme {{{3
" let g:lightline = { 'colorscheme': 'hybrid' }
" set background=dark
" let g:hybrid_italic=0       " hybridでitalicをオフ
" colorscheme hybrid

" nord colorscheme {{{3
" let g:lightline = { 'colorscheme': 'nord' }
" let g:nord_cursor_line_number_background = 1
" colorscheme nord

" gruvbox colorscheme {{{3
" let g:lightline = { 'colorscheme': 'gruvbox' }
" set background=dark
" colorscheme gruvbox

let g:lightline = { 'colorscheme': 'solarized' }
set background=dark
let g:solarized_bold = 0
colorscheme solarized


" " memolist.vim {{{2
" let g:memolist_path         = expand('~/Dropbox/u/201100_memolist')
" let g:memolist_memo_suffix  = 'md'
" " let g:memolist_fzf          = 1
" nnoremap <Leader>mn  :MemoNew<CR>
" nnoremap <Leader>ml  :MemoList<CR>
" nnoremap <Leader>mg  :MemoGrep<CR>
" 
" notational-fzf-vim {{{2
let g:nv_search_paths   = [
  \ '~/Documents/MyNotes/201100_qfixhowm',
  \ '~/Documents/MyNotes/190900_coteditor',
  \ '~/Documents/MyNotes/201117_Org' ]
let g:nv_create_note_window = 'tabedit'
nnoremap <silent> <Leader>nv :NV<CR>
" 
" qfixhorm {{{2
" qfixappにruntimepathを通す
set runtimepath+=~/.vim/vimfiles/pluginjp/qfixapp
" キーマップリーダー
let QFixHowm_Key = 'g'
" howm_dirはファイルを保存したいディレクトリを設定
let howm_dir             = '~/Documents/MyNotes/201100_qfixhowm'
let howm_filename        = '%Y/%m/%Y-%m-%d-%H%M%S.txt'
let howm_fileencoding    = 'utf-8'
let howm_fileformat      = 'unix'
" クイックメモのファイル名(月ごと) 
let QFixHowm_QuickMemoFile = 'Qmem-00-%Y-%m-00-000000.txt'
" QFixHowmのファイルタイプ
let QFixHowm_FileType = 'qfix_memo'
"新規エントリのテンプレート
let QFixHowm_Template = [
  \"= ",
  \"",
  \""
\]
" エントリの更新日時を自動更新
let QFixHowm_RecentMode = 2
" カーソル下の単語を検索ワードにする
let MyGrep_DefaultSearchWord = 1
" とりあえず有効にし、なにか問題が起きたら無効化するのをおすすめします
" プレビューや絞り込みをQuickFix/ロケーションリストの両方で有効化(デフォルト:2)
let QFixWin_EnableMode = 1
" QFixHowm/QFixGrepの結果表示にロケーションリストを使用する/しない
let QFix_UseLocationList = 1
" キーコードやマッピングされたキー列が完了するのを待つ時間(ミリ秒)
set timeout timeoutlen=3000 ttimeoutlen=100

" }}}

" ft-changelog {{{2
" delete later...2020-11-15
" エントリのフォーマット
" let g:changelog_username = "mi"
" let g:changelog_dateformat = "%Y-%m-%d"
" let g:changelog_new_date_format = "%d  %u\n\n  * %c: \n\n\n"
" let g:changelog_new_entry_format = "  * %c: "
" }}}


" 9: 出典リスト {{{1
" 1: マスタリングVim Ruslan Osipov
" 2: Vim & Emacsエキスパート活用術 SD別冊
" 3: https://github.com/cohama/.vim/blob/master/init.vim
" 4: https://github.com/deris/dotfiles/blob/master/.vimrc
" 5: https://sites.google.com/site/fudist/Home/vim-nihongo-ban/tips/vim-key-emacs
"
"" }}}


" modeline {{{1
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
"

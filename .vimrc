" templates
if has('autocmd')
    autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl
endif

" pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()

" vim stuffs
filetype plugin indent on
syntax on
set number
set mouse=""
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set noshowmode

" tilde backup files
if has("vms")
  set nobackup
else
  set backup
  set backupdir=~/.vim/backups,/tmp
endif

" Colors/themes
set background=dark
colorscheme solarized

" airline: https://github.com/bling/vim-airline
set laststatus=2
let g:airline_powerline_fonts = 1

" jshint
let jshint2_save = 1
let jshint2_read = 1

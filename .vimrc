if has('autocmd')
    autocmd BufNewFile * silent! 0r $HOME/.vim/templates/%:e.tpl
endif

" pathogen: https://github.com/tpope/vim-pathogen
execute pathogen#infect()
set mouse=""

if has("vms")
  set nobackup
else
  set backup
  set backupdir=~/.vim/backups,/tmp
endif

set number

set smartindent
set tabstop=4
set shiftwidth=4
set expandtab


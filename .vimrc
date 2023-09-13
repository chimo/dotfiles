filetype plugin indent on

" Set gitgutter's column background colour as 'transparent'
highlight SignColumn guibg=NONE ctermbg=NONE

set background=dark         " tell vim/plugins our background is dark
set cc=80                   " highlight the 80th column (the default textwidth)
set expandtab               " convert tabs into spaces
set mouse=""                " disable mouse
set number                  " show line numbers
set shiftwidth=4            " four spaces per indentation level
set smartindent             " have vim figure out when to indent
"set spell spelllang=en_ca  " highlight misspelled words
set tabstop=4               " four spaces per 'tab' press
set updatetime=100          " lessen delay so git-gutter appears more seamless
                            " Note: also controls the delay before vim writes
                            " its swap file

syntax on                   " pretty colours (syntax highlighting)


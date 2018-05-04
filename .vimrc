filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" Let o,O start at indent
set autoindent
" show the cursor position all the time
set ruler

" do not keep a backup file, use versions instead
set nobackup

" http://vimdoc.sourceforge.net/htmldoc/spell.html
"set spell spelllang=en_us
set spellfile=~/.vim/spell/en.utf-8.add

" By default, when pressing left/right cursor keys, Vim will not move to the
" previous/next line after reaching first/last character in the line.
" This causes the left and right arrow keys, as well as h and l, to wrap when
" used at beginning or end of lines. ( < > are the cursor keys used in normal
" and visual mode, and [ ] are the cursor keys in insert mode).
"
" http://vim.wikia.com/wiki/Automatically_wrap_left_and_right
set whichwrap+=<,>,h,l,[,]
autocmd Filetype gitcommit setlocal spell textwidth=72

" don't reindent anything while pasting
set paste
" colorscheme pablo
" http://vi.stackexchange.com/a/357
set colorcolumn=74,79,100

" http://vignette3.wikia.nocookie.net/vim/images/1/16/Xterm-color-table.png/revision/latest?cb=20110121055231
highlight ColorColumn ctermbg=8

" wrapped lines indent same as first
set breakindent

" line numbers
set number

" mark tabs red
highlight SpecialKey ctermfg=1
set list
set listchars=tab:T>

" highlight trailing whitespace
:highlight ExtraWhitespace ctermbg=red guibg=red
:match ExtraWhitespace /\s\+$/

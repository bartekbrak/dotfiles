" copy-pasted from .vimrc, probably needs attention, a lot of things in nvim
" are on by default
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
" set paste
"colorscheme pablo
" http://vi.stackexchange.com/a/357
set colorcolumn=50,72,80

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

" trim trailing whitespace in extensions
autocmd BufWritePre {*.html,*.py,*.md} :%s/\s\+$//e

" regenrate spelling after merging dictionaries on different machines
" https://vi.stackexchange.com/a/5052
for d in glob('~/.vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
        exec 'mkspell! ' . fnameescape(d)
    endif
endfor
set expandtab       " Expand TABs to spaces
set textwidth=80    " prefered, not enforced, for reflowing with gq
set relativenumber

" modeline enables per-file configuration
" https://stackoverflow.com/a/40640857
set modeline

" tabs are cool
map <Tab> gt

" use "true color" in the terminal
" https://github.com/neovim/neovim/wiki/FAQ#how-can-i-use-true-color-in-the-terminal
"set termguicolors

" use system clipboard as default
" https://www.reddit.com/r/neovim/comments/3fricd/easiest_way_to_copy_from_neovim_to_system/
set clipboard+=unnamedplus
colo pablo
syntax on

syntax on
filetype on

call plug#begin('~/.vim/plugged')
Plug 'flrnprz/plastic.vim'
Plug 'jansenm/vim-cmake'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'kana/vim-operator-user'
Plug 'pboettch/vim-cmake-syntax'
Plug 'rhysd/vim-clang-format'
Plug 'rking/ag.vim'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vhdirk/vim-cmake'
Plug 'wlemuel/vim-tldr'
call plug#end()

colorscheme plastic

autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType cpp setlocal sw=4 ts=4 sts=4 expandtab
autocmd BufWritePre *.py,*.js,*.cpp,*.c,*.cc,*.cxx,*.h,*.hpp,*.hxx :call <SID>StripTrailingWhitespaces()

autocmd BufNewFile,BufRead *.c setfiletype cpp

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction

set clipboard=unnamed
set hidden
set makeprg=ninja\ -C\ ./build
set noswapfile
set nowritebackup
set number
set relativenumber
set updatetime=100
map <space> <leader>

let g:clang_format#command = "clang-format-8"

nmap <leader>gr :Rg <C-r><C-w><CR>
nmap <leader>gw :Rg \b<C-r><C-w>\b<CR>
nmap <leader>cf :ClangFormat<CR>:w<CR>
vmap <leader>s :sort<CR>
nmap <expr> <leader>bf ':cfile ' . $CERR_LOCATION . '<CR>'

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)


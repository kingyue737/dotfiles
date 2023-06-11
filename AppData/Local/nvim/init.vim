if exists('g:vscode')
    autocmd InsertLeave * :silent :!C:\\tools\\neovim\\im-select.exe 1033
    autocmd InsertEnter * :silent :!C:\\tools\\neovim\\im-select.exe 2052
else
endif
if exists('g:vscode')
    autocmd InsertLeave * :silent :!"C:\Program Files\im-select.exe" 1033
    autocmd InsertEnter * :silent :!"C:\Program Files\im-select.exe" 2052
else
endif
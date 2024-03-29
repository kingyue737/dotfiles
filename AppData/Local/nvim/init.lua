local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
         lazypath})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({{
    "kylechui/nvim-surround",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
        require("nvim-surround").setup({
            -- Configuration here, or leave empty to use defaults
        })
    end
}, {
    'keaising/im-select.nvim',
    config = function()
        require('im_select').setup {
            default_command = 'C:\\Program Files\\im-select.exe'
        }
    end
}, {
    'vscode-neovim/vscode-multi-cursor.nvim',
    event = 'VeryLazy',
    cond = not not vim.g.vscode,
    opts = {},
    config = function()
        require('vscode-multi-cursor').setup {
            -- Whether to set default mappings
            default_mappings = true,
            -- If set to true, only multiple cursors will be created without multiple selections
            no_selection = false
        }
    end
}})


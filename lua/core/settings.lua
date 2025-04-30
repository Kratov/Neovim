-- lua/core/settings.lua

-- ─[ Leader and Env Setup ]────────────────────────────
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- NOTE (JAIME): Remember to install `ripgrep` and `fd` via Chocolatey:
-- choco install ripgrep fd

vim.g.copilot_proxy_strict_ssl = false
-- vim.g.copilot_node_command = 'C:\\Program Files\\nodejs\\node.exe'
-- vim.g.copilot_workspace_folders = { "C:\\Users\\jzamora1\\Documents\\Spring" }

vim.fn.setenv("NODE_TLS_REJECT_UNAUTHORIZED", "0")

-- ─[ General Neovim Options ]──────────────────────────
vim.o.hlsearch        = false
vim.wo.number         = true
vim.wo.relativenumber = true
vim.o.mouse           = 'a'
vim.o.clipboard       = 'unnamedplus'
vim.o.breakindent     = true
vim.o.undofile        = true
vim.o.ignorecase      = true
vim.o.smartcase       = true
vim.wo.signcolumn     = 'yes'
vim.o.updatetime      = 250
vim.o.timeoutlen      = 300
vim.o.completeopt     = 'menuone,noselect'
vim.o.termguicolors   = true

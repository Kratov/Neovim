-- lua/core/lsp.lua
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix','refactor','source' } }, apply = true }
  end, '[C]ode [A]ction')
  nmap('gd', function() Snacks.picker.lsp_definitions() end, '[G]oto [D]efinition')
  nmap('gr', function() Snacks.picker.lsp_references() end, '[G]oto [R]eferences')
  nmap('gI', function() Snacks.picker.lsp_implementations() end, '[G]oto [I]mplementation')
  nmap('<leader>D', function() Snacks.picker.lsp_type_definitions() end, 'Type [D]efinition')
  nmap('<leader>ds', function() Snacks.picker.lsp_symbols() end, '[D]ocument [S]ymbols')
  nmap('<leader>ws', function() Snacks.picker.lsp_workspace_symbols() end, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function() vim.lsp.buf.format() end, { desc = 'Format current buffer with LSP' })
end

require('neodev').setup()
require('mason').setup()
require('mason-lspconfig').setup {
  ensure_installed = { 'lua_ls', 'pyright', 'tailwindcss' },
}

local caps = vim.lsp.protocol.make_client_capabilities()
caps.offsetEncoding = { 'utf-8' }
local capabilities = require('cmp_nvim_lsp').default_capabilities(caps)

-- New API
vim.lsp.config('*', {
  on_attach = on_attach,
  capabilities = capabilities,
})

vim.lsp.config('pyright', {
  before_init = function(_, config) config.offsetEncoding = { 'utf-8' } end,
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        autoImportCompletions = true,
      },
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable({ 'lua_ls', 'pyright', 'tailwindcss' })

vim.keymap.set('n', '<leader>l', function()
  require('lint').try_lint()
end, { desc = 'Trigger linting for current file' })

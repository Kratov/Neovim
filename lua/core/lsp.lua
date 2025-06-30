
-- lua/core/lsp.lua

-- ─[ LSP Setup ]──────────────────────────────────────
local on_attach = function(_, bufnr)
  local nmap = function(keys, func, desc)
    if desc then desc = 'LSP: ' .. desc end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local builtin = require('telescope.builtin')
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix','refactor','source' } }, apply = true }
  end, '[C]ode [A]ction')
  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')
  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
  nmap('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, '[W]orkspace [L]ist Folders')

  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- ─[ Initialize Mason & Mason‐LSPConfig ]────────────────────────
require('neodev').setup()
require('mason').setup()
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup {
  ensure_installed = { 'lua_ls', 'pyright', 'tailwindcss' },
}

-- ⚙️ Capabilities (force UTF-8)
local caps = vim.lsp.protocol.make_client_capabilities()
caps.offsetEncoding = { 'utf-8' }
local capabilities = require('cmp_nvim_lsp').default_capabilities(caps)

-- ─[ Setup each server in a simple loop ]────────────────────────
local lspconfig = require('lspconfig')
for _, server in ipairs(mason_lspconfig.get_installed_servers()) do
  local opts = {
    on_attach   = on_attach,
    capabilities = capabilities,
  }

  if server == 'pyright' then
    opts.before_init = function(_, config) config.offsetEncoding = { 'utf-8' } end
    opts.settings = {
      python = {
        analysis = {
          autoSearchPaths        = true,
          diagnosticMode         = 'openFilesOnly',
          useLibraryCodeForTypes = true,
        },
      },
    }
  elseif server == 'lua_ls' then
    opts.settings = {
      Lua = {
        workspace = { checkThirdParty = false },
        telemetry  = { enable = false },
      },
    }
  end

  lspconfig[server].setup(opts)
end

-- 🔧 Optional: Manual lint command
vim.keymap.set('n', '<leader>l', function()
  require('lint').try_lint()
end, { desc = 'Trigger linting for current file' })


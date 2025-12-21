-- lua/core/keymaps.lua

-- ─[ General Keymaps ]────────────────────────────────
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Handle line wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'List diagnostics' })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Which-key registration
local wk = require('which-key')
wk.add({
  { "<leader>c", group = "[C]ode" },
  { "<leader>d", group = "[D]ocument" },
  { "<leader>g", group = "[G]it" },
  { "<leader>h", group = "Git [H]unk" },
  { "<leader>r", group = "[R]ename" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>t", group = "[T]oggle" },
  { "<leader>w", group = "[W]orkspace" },
})

-- Visual mode groups
wk.add({
  { "<leader>h", group = "Git [H]unk" },
}, { mode = "v" })

-- Database

vim.keymap.set('n', '<leader>Dt', ':DBUIToggle<CR>', { desc = 'Toggle DB UI' })

vim.keymap.set('n', '<leader>Da', ':DBUIAddConnection<CR>', { desc = 'Add DB Connection' })
vim.keymap.set('n', '<leader>Df', ':DBUIFindBuffer<CR>', { desc = 'Find DB Buffer' })

-- Add to which-key registration
wk.add({
  { "<leader>D", group = "[D]atabase" },
})

-- Molten (Jupyter)
-- Molten
vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>', { desc = 'Init kernel' })
vim.keymap.set('n', '<leader>me', ':MoltenEvaluateOperator<CR>', { desc = 'Eval operator' })
vim.keymap.set('n', '<leader>ml', ':MoltenEvaluateLine<CR>', { desc = 'Run line' })
vim.keymap.set('n', '<leader>mr', ':MoltenReevaluateCell<CR>', { desc = 'Re-run cell' })
vim.keymap.set('v', '<leader>mv', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = 'Run selection' })
vim.keymap.set('n', '<leader>mo', ':MoltenShowOutput<CR>', { desc = 'Show output' })
vim.keymap.set('n', '<leader>mh', ':MoltenHideOutput<CR>', { desc = 'Hide output' })
vim.keymap.set('n', '<leader>md', ':MoltenDelete<CR>', { desc = 'Delete cell' })
-- Register with which-key
wk.add({
  { "<leader>m", group = "[M]olten" },
})

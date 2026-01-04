-- lua/core/keymaps.lua

-- ─[ General Keymaps ]────────────────────────────────
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Handle line wrap navigation
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- ─[ Buffer Navigation ]─────────────────────────────
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', '<S-l>', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '[b', '<cmd>bprevious<cr>', { desc = 'Prev Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<cr>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- ─[ Window Navigation ]─────────────────────────────
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window' })

-- Terminal mode window navigation (for OpenCode, terminals, etc.)
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Go to Lower Window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Go to Upper Window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Go to Right Window' })

-- Diagnostic navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Show diagnostic' })
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
  { "<leader>b", group = "[B]uffer" },
  { "<leader>c", group = "[C]ode" },
  { "<leader>d", group = "[D]ocument" },
  { "<leader>g", group = "[G]it" },
  { "<leader>h", group = "Git [H]unk" },
  { "<leader>n", group = "[N]otifications" },
  { "<leader>r", group = "[R]ename" },
  { "<leader>s", group = "[S]earch" },
  { "<leader>t", group = "[T]oggle" },
  { "<leader>u", group = "[U]I Toggles" },
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

-- lua/core/telescope.lua

-- ─[ Telescope Setup ]────────────────────────────────
local telescope = require('telescope')
local builtin = require('telescope.builtin')

-- Configure telescope

local function find_git_root()
  local current_file = vim.api.nvim_buf_get_name(0)
  local cwd = vim.fn.getcwd()
  local current_dir = (current_file == '') and cwd or vim.fn.fnamemodify(current_file, ':h')
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]

  if vim.v.shell_error ~= 0 then
    print('Not a git repo, using CWD')
    return cwd
  end
  return git_root
end

local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    builtin.live_grep { search_dirs = { git_root } }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- Setup telescope defaults and pickers
telescope.setup {
  pickers = {
    find_files = {
      hidden = true,
      find_command = {
        'rg', '--files',
        '--glob', '!{.git/*,.svelte-kit/*,target/*,node_modules/*}',
        '--path-separator', '/',
      },
    },
  },

defaults = {
  layout_strategy = 'horizontal',
  layout_config = {
    preview_width = 0.6,
    width = 0.9,
    preview_cutoff = 120, -- muestra preview solo si ventana ≥120 cols
  },
}

}

-- Load native fzf if available
pcall(telescope.load_extension, 'fzf')

-- Keymaps
vim.keymap.set('n', '<leader>?', builtin.oldfiles, { desc = '[?] Recent files' })
vim.keymap.set('n', '<leader><space>', builtin.buffers, { desc = '[ ] Buffers' })
vim.keymap.set('n', '<leader>*', builtin.git_branches, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>/', function()
  builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = 'Fuzzy search buffer' })

vim.keymap.set('n', '<leader>s/', function()
  builtin.live_grep { grep_open_files = true, prompt_title = 'Grep Open Files' }
end, { desc = 'Live grep open files' })

vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = 'Telescope Builtins' })
vim.keymap.set('n', '<leader>gf', builtin.git_files, { desc = 'Git Files' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Help Tags' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search Word' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<CR>', { desc = 'Live Grep Git Root' })
vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume Last Search' })

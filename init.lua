--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
--  NOTE: JAIME remember to instal ripgrep and fd with Chocolatey
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.copilot_proxy_strict_ssl = false
--vim.g.copilot_node_command = 'C:\\Program Files\\nodejs\\node.exe'
--vim.g.copilot_workspace_folders = { "C:\\Users\\jzamora1\\Documents\\Spring" }

vim.fn.setenv("NODE_TLS_REJECT_UNAUTHORIZED", "0")

-- [[ Install `lazy.nvim` plugin manager ]]
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  -- require 'kickstart.plugins.autoformat'vim-test/vim-test,
  "nvim-neotest/nvim-nio",
  { import = 'custom.plugins' },
}, {})



-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Relativize line numbers
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- [[ Basic Keymaps ]]

-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  pickers = {
        find_files = {
          hidden = true,
          find_command = {
            "rg",
            "--files",
            "--glob",
            "!{.git/*,.svelte-kit/*,target/*,node_modules/*}",
            "--path-separator",
            "/",
          },
        },
      },
  defaults = {
    layout_strategy = 'vertical',
    layout_config = {
      vertical = {
        width = 0.5
      }
    },
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- colorizer preview
require('colorizer').setup()

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>*', require('telescope.builtin').git_branches, { desc = 'Manage [B]ranches' })

vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

local function telescope_live_grep_open_files()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end
vim.keymap.set('n', '<leader>s/', telescope_live_grep_open_files, { desc = '[S]earch [/] in Open Files' })
vim.keymap.set('n', '<leader>ss', require('telescope.builtin').builtin, { desc = '[S]earch [S]elect Telescope' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Search [G]it [F]iles' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sG', ':LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = '[S]earch [R]esume' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'

require('nvim-treesitter.install').compilers = { 'zig' }

vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim', 'bash' },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,
    -- Install languages synchronously (only applied to `ensure_installed`)
    sync_install = false,
    -- List of parsers to ignore installing
    ignore_install = {},
    -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  nmap('<leader>ca', function()
    vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
  end, '[C]ode [A]ction')


local telescope_builtin = require('telescope.builtin')

-- Function to open the log buffer in a horizontal split at the bottom
local function open_log_buffer()
  -- Check if the buffer exists
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(buf) == "Dotnet Logs" then
      -- Reuse the existing buffer
      return buf
    end
  end

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true) -- Create a new unlisted buffer
  vim.api.nvim_buf_set_name(buf, "Dotnet Logs") -- Set buffer name
  vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe') -- Auto-remove when hidden
  -- Open the buffer in a horizontal split at the bottom of the screen
  vim.cmd('botright split')  -- Open the split at the bottom
  vim.api.nvim_win_set_buf(0, buf) -- Set the buffer in the current window
  vim.api.nvim_win_set_height(0, 10) -- Set the height of the split
  return buf
end

-- Function to run dotnet project and log the output
vim.keymap.set('n', '<leader>cr', function()
  telescope_builtin.find_files({
    prompt_title = 'Select .NET Project',
    search_dirs = { '.' },
    find_command = { 'fd', '--type', 'f', '--glob', '*.csproj', '--no-ignore-vcs', '--no-follow' },
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        local selected_project = require('telescope.actions.state').get_selected_entry()
        require('telescope.actions').close(prompt_bufnr)

        -- Open the log buffer in a split window at the bottom to monitor the app's output
        local log_buf = open_log_buffer()

        -- Clear previous content in the log buffer
        vim.api.nvim_buf_set_lines(log_buf, 0, -1, false, {})

        -- Asynchronous job for `dotnet run`
        local job_id = vim.fn.jobstart("dotnet run --project " .. selected_project.path, {
          stdout_buffered = false,  -- Real-time output
          stderr_buffered = false,
          on_stdout = function(_, data, _)
            if data then
              -- Append the stdout logs to the buffer
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, data)
              vim.api.nvim_command("normal! G")  -- Auto-scroll to the bottom
            end
          end,
          on_stderr = function(_, data, _)
            if data then
              -- Append the stderr logs to the buffer (in case of errors)
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, data)
              vim.api.nvim_command("normal! G")  -- Auto-scroll to the bottom
            end
          end,
          on_exit = function(_, exit_code, _)
            -- Notify the user when the app finishes or crashes
            if exit_code == 0 then
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, { "Project ran successfully" })
            else
              vim.api.nvim_buf_set_lines(log_buf, -1, -1, false, { "Project failed to run" })
            end
            vim.api.nvim_command("normal! G")  -- Auto-scroll to the bottom
          end
        })

        -- Automatically kill the job when the buffer is closed
        vim.api.nvim_create_autocmd("BufWipeout", {
          buffer = log_buf,
          callback = function()
            -- Kill the dotnet process if it's still running
            if job_id > 0 then
              vim.fn.jobstop(job_id)
              print("dotnet process killed")
            end
          end
        })
      end)
      return true
    end
  })
end, { desc = '[C]ode [R]un selected .NET project with Telescope' })

  local builtin = require('telescope.builtin')

  nmap('gr', builtin.lsp_references, '[G]oto [R]eferences')
  nmap('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
  nmap('gd', builtin.lsp_definitions, '[G]oto [D]efinition')  -- Added gd mapping for go-to-definition
  nmap('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
  nmap('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end


require("transparent").setup({ -- Optional, you don't have to run setup.
  groups = {                   -- table: default groups
    'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
    'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
    'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
    'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
    'EndOfBuffer',
  },
  extra_groups = {},   -- table: additional groups that should be cleared
  exclude_groups = {}, -- table: groups you don't want to clear
})

-- document existing key chains
local wk = require('which-key')

wk.add({
  { "<leader>c", group = "[C]ode" }, -- Code group
  { "<leader>d", group = "[D]ocument" }, -- Document group
  { "<leader>g", group = "[G]it" }, -- Git group
  { "<leader>h", group = "Git [H]unk" }, -- Git Hunk group
  { "<leader>r", group = "[R]ename" }, -- Rename group
  { "<leader>s", group = "[S]earch" }, -- Search group
  { "<leader>t", group = "[T]oggle" }, -- Toggle group
  { "<leader>w", group = "[W]orkspace" }, -- Workspace group
})

-- Required for visual <leader>hs (hunk stage) to work
wk.add({
  { "<leader>h", group = "Git [H]unk" }, -- Visual mode Git Hunk group
}, { mode = "v" }) -- Visual mode registration

require('mason').setup()
require('mason-lspconfig').setup()

local servers = {
  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
  
}

mason_lspconfig.setup_handlers {
  function(server_name) -- default handler (optional)
    -- https://github.com/neovim/nvim-lspconfig/pull/3232
    if server_name == "tsserver" then
      server_name = "ts_ls"
    end
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    require("lspconfig")[server_name].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
}



vim.keymap.set(
  "n", "<leader>l", function()
    local lint = require('lint')
    lint.try_lint()
  end, {
    desc = 'Trigger linting current file'
  })


-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require 'lspkind'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),


  },
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  sorting = {
    priority_weight = 2,
    comparators = {

      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.locality,
      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50, 
      ellipsis_char = '...',   
      show_labelDetails = true, 
    }),
  },

  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<Tab>"] = vim.schedule_wrap(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      else
        fallback()
      end
    end),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },

  require('nvim-jest').setup {
    jest_cmd = 'npx jest',
    silent = false,
  }
}


# Neovim Configuration

```
        ██╗  ██╗██████╗        ████████╗ ██████╗ ██╗   ██╗
        ██║ ██╔╝██╔══██╗ ██╗   ╚══██╔══╝██╔═████╗██║   ██║
        █████╔╝ ██████╔╝████║     ██║   ██║██╔██║██║   ██║
        ██╔═██╗ ██╔══██╗╚═██║     ██║   ████╔╝██║╚██╗ ██╔╝
        ██║  ██╗██║  ██║  ╚═╝     ██║   ╚██████╔╝ ╚████╔╝ 
        ╚═╝  ╚═╝╚═╝  ╚═╝          ╚═╝    ╚═════╝   ╚═══╝  
        ─────────────────────────────────────────────────
          > ВЗЛОМ СИСТЕМЫ ОБНАРУЖЕН_
          > ИДЕНТИФИКАЦИЯ: Kr@t0v  [ЗАСЕКРЕЧЕНО]
          > СТАТУС: АКТИВЕН                 ░▒▓█ ARCH █▓▒░
```

A personal Neovim configuration with a cyberpunk aesthetic, powered by **snacks.nvim** and **lazy.nvim**.

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Leader Key](#leader-key)
- [Keybindings](#keybindings)
  - [General](#general)
  - [File Explorer](#file-explorer-snacksexplorer)
  - [Picker / Search](#picker--search-snackspicker)
  - [LSP](#lsp)
  - [Git](#git)
  - [Debugging](#debugging-nvim-dap)
  - [Database](#database-dadbod)
  - [Jupyter / Molten](#jupyter--molten)
  - [UI Toggles](#ui-toggles)
  - [Zen Mode](#zen-mode)
  - [Notifications](#notifications)
  - [Terminal](#terminal)
  - [Buffers](#buffers)
  - [Comments](#comments)
  - [Surround](#surround)
- [Plugins](#plugins)

---

## Requirements

- Neovim >= 0.9.4
- [Kitty](https://sw.kovidgoyal.net/kitty/), [WezTerm](https://wezfurlong.org/wezterm/), or [Ghostty](https://ghostty.org/) terminal (for image support)
- [Nerd Font](https://www.nerdfonts.com/) (for icons)
- [ripgrep](https://github.com/BurntSushi/ripgrep) (for grep/search)
- [fd](https://github.com/sharkdp/fd) (for file finding)
- [lazygit](https://github.com/jesseduffield/lazygit) (for git integration)
- Node.js (for Copilot, LSP servers)
- Python 3 with `pynvim` (for Molten)

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this config
git clone <your-repo> ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

Run `:Lazy sync` to ensure all plugins are installed, then `:checkhealth` to verify setup.

---

## Leader Key

The leader key is **`<Space>`**.

All keybindings prefixed with `<leader>` mean pressing Space first.

---

## Keybindings

### General

| Key | Mode | Description |
|-----|------|-------------|
| `j` / `k` | n | Smart line navigation (respects wrapped lines) |
| `[d` | n | Go to previous diagnostic |
| `]d` | n | Go to next diagnostic |
| `<leader>e` | n | Show diagnostic float |
| `<leader>q` | n | Send diagnostics to location list |
| `<leader>l` | n | Trigger linting for current file |

### File Explorer (snacks.explorer)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>E` | n | Toggle file explorer |

### Picker / Search (snacks.picker)

#### Quick Access

| Key | Mode | Description |
|-----|------|-------------|
| `<leader><space>` | n | Open buffers |
| `<leader>?` | n | Recent files |
| `<leader>/` | n | Fuzzy search in current buffer |
| `<leader>*` | n | Git branches |

#### Search (`<leader>s`)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>sf` | n | Find files |
| `<leader>sg` | n | Live grep (search text) |
| `<leader>sG` | n | Live grep from git root |
| `<leader>sw` | n, x | Search word under cursor |
| `<leader>sh` | n | Search help tags |
| `<leader>sk` | n | Search keymaps |
| `<leader>sm` | n | Search marks |
| `<leader>sj` | n | Search jump list |
| `<leader>sc` | n | Command history |
| `<leader>sC` | n | Search commands |
| `<leader>s:` | n | Command history |
| `<leader>sq` | n | Quickfix list |
| `<leader>sl` | n | Location list |
| `<leader>sd` | n | Search diagnostics (all) |
| `<leader>sD` | n | Search diagnostics (buffer) |
| `<leader>sr` | n | Resume last search |
| `<leader>su` | n | Undo history |
| `<leader>s'` | n | Registers |
| `<leader>s/` | n | Grep open buffers |
| `<leader>ss` | n | List all pickers |

### LSP

| Key | Mode | Description |
|-----|------|-------------|
| `gd` | n | Go to definition |
| `gD` | n | Go to declaration |
| `gr` | n | Go to references |
| `gI` | n | Go to implementation |
| `K` | n | Hover documentation |
| `<C-k>` | n | Signature help |
| `<leader>rn` | n | Rename symbol |
| `<leader>ca` | n | Code action |
| `<leader>D` | n | Type definition |
| `<leader>ds` | n | Document symbols |
| `<leader>ws` | n | Workspace symbols |
| `<leader>wa` | n | Add workspace folder |
| `<leader>wr` | n | Remove workspace folder |
| `<leader>wl` | n | List workspace folders |
| `]]` | n, t | Jump to next LSP reference |
| `[[` | n, t | Jump to previous LSP reference |
| `:Format` | cmd | Format current buffer |

### Git

#### Snacks Git Integration

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>gg` | n | Open Lazygit |
| `<leader>gB` | n, v | Open current file in browser (GitHub/GitLab) |
| `<leader>gf` | n | Git files |
| `<leader>gl` | n | Git log |
| `<leader>gL` | n | Git log for current line |
| `<leader>gs` | n | Git status |
| `<leader>gd` | n | Git diff (hunks) |

#### Gitsigns (Hunk Operations)

| Key | Mode | Description |
|-----|------|-------------|
| `]c` | n, v | Jump to next hunk |
| `[c` | n, v | Jump to previous hunk |
| `<leader>hs` | n | Stage hunk |
| `<leader>hs` | v | Stage selected hunk |
| `<leader>hr` | n | Reset hunk |
| `<leader>hr` | v | Reset selected hunk |
| `<leader>hS` | n | Stage buffer |
| `<leader>hu` | n | Undo stage hunk |
| `<leader>hR` | n | Reset buffer |
| `<leader>hp` | n | Preview hunk |
| `<leader>hb` | n | Blame line |
| `<leader>hd` | n | Diff against index |
| `<leader>hD` | n | Diff against last commit |
| `<leader>tb` | n | Toggle line blame |
| `<leader>td` | n | Toggle show deleted |
| `ih` | o, x | Select hunk (text object) |

#### Fugitive

| Command | Description |
|---------|-------------|
| `:Git` | Open Git status |
| `:Git blame` | Git blame |
| `:Git diff` | Git diff |
| `:Git log` | Git log |
| `:GBrowse` | Open in browser (with vim-rhubarb) |

### Debugging (nvim-dap)

| Key | Mode | Description |
|-----|------|-------------|
| `<F5>` | n | Start/Continue debugging |
| `<F6>` | n | Step into |
| `<F7>` | n | Step over |
| `<F8>` | n | Step out |
| `<F9>` | n | Toggle DAP UI |
| `<leader>Db` | n | Toggle breakpoint |
| `<leader>DB` | n | Set conditional breakpoint |
| `<leader>Dh` | n | Hover variable |

### Database (dadbod)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>Dt` | n | Toggle DB UI |
| `<leader>Da` | n | Add DB connection |
| `<leader>Df` | n | Find DB buffer |

### Jupyter / Molten

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>mi` | n | Initialize kernel |
| `<leader>me` | n | Evaluate operator |
| `<leader>ml` | n | Run current line |
| `<leader>mr` | n | Re-run cell |
| `<leader>mv` | v | Run selection |
| `<leader>mo` | n | Show output |
| `<leader>mh` | n | Hide output |
| `<leader>md` | n | Delete cell |

### UI Toggles (`<leader>u`)

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>us` | n | Toggle spell checking |
| `<leader>uw` | n | Toggle line wrap |
| `<leader>uL` | n | Toggle relative line numbers |
| `<leader>ul` | n | Toggle line numbers |
| `<leader>ud` | n | Toggle diagnostics |
| `<leader>uc` | n | Toggle conceal level |
| `<leader>uT` | n | Toggle treesitter highlight |
| `<leader>ub` | n | Toggle dark/light background |
| `<leader>uh` | n | Toggle inlay hints |
| `<leader>ug` | n | Toggle indent guides |
| `<leader>uD` | n | Toggle dim inactive code |
| `<leader>uC` | n | Pick colorscheme |

### Zen Mode

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>z` | n | Toggle Zen mode |
| `<leader>Z` | n | Toggle Zoom (maximize window) |

### Notifications

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>un` | n | Dismiss all notifications |
| `<leader>nh` | n | Show notification history |
| `<leader>nl` | n | Show last message |
| `<leader>ne` | n | Show errors |
| `<leader>nd` | n | Dismiss all messages |

### Terminal

| Key | Mode | Description |
|-----|------|-------------|
| `<C-/>` | n | Toggle floating terminal |

### Buffers

| Key | Mode | Description |
|-----|------|-------------|
| `<S-h>` | n | Previous buffer |
| `<S-l>` | n | Next buffer |
| `[b` | n | Previous buffer |
| `]b` | n | Next buffer |
| `<leader>bb` | n | Switch to alternate buffer |
| `<leader>\`` | n | Switch to alternate buffer |
| `<leader>bd` | n | Delete buffer (preserves layout) |

### Scratch Buffers

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>.` | n | Toggle scratch buffer |
| `<leader>S` | n | Select scratch buffer |

### Code

| Key | Mode | Description |
|-----|------|-------------|
| `<leader>cR` | n | Rename file (LSP-aware) |
| `<leader>cr` | n | Run .NET project |

### Comments (Comment.nvim)

| Key | Mode | Description |
|-----|------|-------------|
| `gcc` | n | Toggle line comment |
| `gbc` | n | Toggle block comment |
| `gc` | v | Toggle comment on selection |
| `gb` | v | Toggle block comment on selection |
| `gcO` | n | Add comment above |
| `gco` | n | Add comment below |
| `gcA` | n | Add comment at end of line |

### Surround (nvim-surround)

| Key | Mode | Description |
|-----|------|-------------|
| `ys{motion}{char}` | n | Add surround |
| `ds{char}` | n | Delete surround |
| `cs{old}{new}` | n | Change surround |
| `S{char}` | v | Surround selection |

**Examples:**
- `ysiw"` - Surround word with quotes
- `ds"` - Delete surrounding quotes
- `cs"'` - Change double quotes to single quotes
- `yss)` - Surround entire line with parentheses

---

## Plugins

### Core (snacks.nvim)

| Feature | Description |
|---------|-------------|
| `dashboard` | Startup screen with quick actions |
| `picker` | Fuzzy finder for files, grep, LSP, git |
| `explorer` | File explorer sidebar |
| `indent` | Animated indent guides with scope highlighting |
| `image` | Image viewer (Kitty Graphics Protocol) |
| `notifier` | Pretty notifications |
| `terminal` | Floating terminal |
| `lazygit` | Lazygit integration |
| `gitbrowse` | Open files in GitHub/GitLab |
| `bufdelete` | Delete buffers without layout disruption |
| `zen` | Zen mode / distraction-free coding |
| `scroll` | Smooth scrolling |
| `statuscolumn` | Pretty status column |
| `words` | LSP reference navigation |
| `scope` | Treesitter-based scope detection |
| `toggle` | UI toggle keymaps |
| `rename` | LSP-aware file renaming |
| `scratch` | Persistent scratch buffers |
| `dim` | Dim inactive code |
| `bigfile` | Handle large files gracefully |
| `quickfile` | Fast file rendering on startup |
| `input` | Better vim.ui.input |

### Git

| Plugin | Description |
|--------|-------------|
| `gitsigns.nvim` | Git gutter signs, hunk operations |
| `vim-fugitive` | Git commands |
| `vim-rhubarb` | GitHub integration for fugitive |

### LSP & Completion

| Plugin | Description |
|--------|-------------|
| `nvim-lspconfig` | LSP configuration |
| `mason.nvim` | LSP/DAP/Linter installer |
| `mason-lspconfig.nvim` | Mason + lspconfig bridge |
| `nvim-cmp` | Autocompletion |
| `cmp-nvim-lsp` | LSP completion source |
| `cmp-path` | Path completion |
| `cmp-buffer` | Buffer completion |
| `LuaSnip` | Snippet engine |
| `lspkind.nvim` | LSP completion icons |
| `neodev.nvim` | Neovim Lua development |
| `nvim-lint` | Asynchronous linting |
| `trouble.nvim` | Pretty diagnostics list |

### Syntax & Treesitter

| Plugin | Description |
|--------|-------------|
| `nvim-treesitter` | Syntax highlighting, indentation |
| `nvim-treesitter-textobjects` | Treesitter-based text objects |

### Editing

| Plugin | Description |
|--------|-------------|
| `Comment.nvim` | Smart commenting |
| `nvim-surround` | Surround text with pairs |
| `nvim-autopairs` | Auto-close pairs |
| `vim-sleuth` | Auto-detect indentation |

### UI

| Plugin | Description |
|--------|-------------|
| `lualine.nvim` | Statusline |
| `which-key.nvim` | Keybinding hints |
| `onedark.nvim` | Colorscheme |
| `nvim-highlight-colors` | Color highlighting |
| `transparent.nvim` | Transparent background |

### Debugging

| Plugin | Description |
|--------|-------------|
| `nvim-dap` | Debug Adapter Protocol |
| `nvim-dap-ui` | DAP UI |
| `nvim-dap-go` | Go debugging |
| `nvim-dap-virtual-text` | Inline debug values |
| `mason-nvim-dap.nvim` | Mason + DAP integration |

### Database

| Plugin | Description |
|--------|-------------|
| `vim-dadbod` | Database interface |
| `vim-dadbod-ui` | Database UI |
| `vim-dadbod-completion` | SQL completion |

### Jupyter / Notebooks

| Plugin | Description |
|--------|-------------|
| `molten-nvim` | Jupyter notebook support |
| `jupytext.nvim` | Jupyter notebook conversion |

### AI

| Plugin | Description |
|--------|-------------|
| `copilot.vim` | GitHub Copilot |

### Misc

| Plugin | Description |
|--------|-------------|
| `vim-prettier` | Prettier formatting |
| `jest-nvim` | Jest test runner |

---

## Dashboard Quick Actions

When opening Neovim without a file:

| Key | Action |
|-----|--------|
| `f` | Find file |
| `n` | New file |
| `g` | Find text (grep) |
| `r` | Recent files |
| `c` | Open config |
| `s` | Restore session |
| `l` | Open Lazy (plugin manager) |
| `q` | Quit |

---

## Troubleshooting

```vim
" Check plugin health
:checkhealth

" Check snacks specifically
:checkhealth snacks

" View Lazy plugin status
:Lazy

" Sync plugins
:Lazy sync

" View messages/errors
:messages
```

---

## File Structure

```
~/.config/nvim/
├── init.lua                 # Main entry point
├── lua/
│   ├── core/
│   │   ├── settings.lua     # Vim options
│   │   ├── lazy.lua         # Plugin manager setup
│   │   ├── keymaps.lua      # General keymaps
│   │   ├── lsp.lua          # LSP configuration
│   │   ├── cmp.lua          # Completion setup
│   │   ├── picker.lua       # Snacks picker keymaps
│   │   └── dotnet.lua       # .NET integration
│   └── custom/
│       └── plugins/         # Plugin configurations
│           ├── snacks.lua   # Main snacks.nvim config
│           ├── gitsigns.lua
│           ├── treesitter.lua
│           └── ...
└── README.md
```

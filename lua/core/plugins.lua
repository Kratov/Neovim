-- core/plugins.lua
-- Plugin setup using lazy.nvim

require('lazy').setup({
  "nvim-neotest/nvim-nio",
  { import = 'custom.plugins' },
}, {})

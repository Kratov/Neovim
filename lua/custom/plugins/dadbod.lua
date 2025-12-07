-- ~/.config/nvim/lua/plugins/dadbod.lua

return {
  {
    'kristijanhusak/vim-dadbod-ui',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },
    },
    cmd = { 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer' },
    init = function()
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_save_location = vim.fn.stdpath('data') .. '/db_ui'
      vim.g.db_ui_execute_on_save = 0
    end,
    config = function()
      -- Autocomplete for SQL buffers
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'sql', 'mysql', 'plsql' },
        callback = function()
          require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
        end,
      })
    end,
  },
}

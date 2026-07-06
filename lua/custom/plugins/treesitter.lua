return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main', -- master is frozen & broken on Neovim 0.12 (match API changed)
    build = ':TSUpdate',
    config = function()
      local langs = {
        'lua', 'python', 'javascript', 'typescript', 'tsx', 'vim', 'vimdoc',
        'bash', 'markdown', 'markdown_inline', -- markdown_inline needed by render-markdown
      }
      require('nvim-treesitter').install(langs)
      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          -- ponytail: pcall guards filetypes with no installed parser
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
}

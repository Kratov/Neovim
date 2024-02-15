return {
    'stevearc/conform.nvim',
    event = {
      'BufReadPre',
      'BufNewFile'
    },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_tf = {
          javascript = {
            "prettier",
          },
          typescript = {
            "prettier",
          },
          typescriptreact = {
            "prettier",
          },
          javascriptreact = {
            "prettier",
          },
          json = {
            "prettier",
          },
          html = {
            "prettier",
          },
          css = {
            "prettier",
          },
          scss = {
            "prettier",
          },
          less = {
            "prettier",
          },
          graphql = {
            "prettier",
          },
          markdown = {
            "prettier",
          },
          yaml = {
            "prettier",
          },
          lua = {
            "stylua",
          },
        },
        format_on_save = {
          lsp_fallback = true,
          async = false,
          timeout_ms = 500
        }
      })
    end
  }

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {}
    vim.o.autoread = true

    -- OpenCode keymaps using <leader>o prefix
    vim.keymap.set({ "n", "x" }, "<leader>oa", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end, { desc = "Execute action" })
    vim.keymap.set({ "n", "t" }, "<leader>ot", function() require("opencode").toggle() end, { desc = "Toggle opencode" })
    vim.keymap.set({ "n", "x" }, "<leader>or", function() return require("opencode").operator("@this ") end, { expr = true, desc = "Add range" })
    vim.keymap.set("n", "<leader>ol", function() return require("opencode").operator("@this ") .. "_" end, { expr = true, desc = "Add line" })
    vim.keymap.set("n", "<leader>ou", function() require("opencode").command("session.half.page.up") end, { desc = "Half page up" })
    vim.keymap.set("n", "<leader>od", function() require("opencode").command("session.half.page.down") end, { desc = "Half page down" })

    -- Register with which-key
    require("which-key").add({
      { "<leader>o", group = "[O]pencode" },
    })
  end,
}

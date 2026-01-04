-- lua/core/picker.lua

-- ─[ Snacks Picker Setup ]────────────────────────────────

local function find_git_root()
	local current_file = vim.api.nvim_buf_get_name(0)
	local cwd = vim.fn.getcwd()
	local current_dir = (current_file == "") and cwd or vim.fn.fnamemodify(current_file, ":h")
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]

	if vim.v.shell_error ~= 0 then
		return nil
	end
	return git_root
end

local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		Snacks.picker.grep({ cwd = git_root })
	else
		vim.notify("Not a git repo, using CWD", vim.log.levels.WARN)
		Snacks.picker.grep()
	end
end

vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})

-- Keymaps
vim.keymap.set("n", "<leader>?", function() Snacks.picker.recent() end, { desc = "[?] Recent files" })
vim.keymap.set("n", "<leader><space>", function() Snacks.picker.buffers() end, { desc = "[ ] Buffers" })
vim.keymap.set("n", "<leader>*", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>/", function() Snacks.picker.lines() end, { desc = "Fuzzy search buffer" })

vim.keymap.set("n", "<leader>s/", function() Snacks.picker.grep_buffers() end, { desc = "Grep Open Buffers" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.pickers() end, { desc = "Snacks Pickers" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_files() end, { desc = "Git Files" })
vim.keymap.set("n", "<leader>sf", function() Snacks.picker.files() end, { desc = "Find Files" })
vim.keymap.set("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Help Tags" })
vim.keymap.set({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Search Word" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>sG", ":LiveGrepGitRoot<CR>", { desc = "Live Grep Git Root" })
vim.keymap.set("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Diagnostics" })
vim.keymap.set("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Buffer Diagnostics" })
vim.keymap.set("n", "<leader>sr", function() Snacks.picker.resume() end, { desc = "Resume Last Search" })

-- Additional useful pickers
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Keymaps" })
vim.keymap.set("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Marks" })
vim.keymap.set("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Jumps" })
vim.keymap.set("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Commands" })
vim.keymap.set("n", "<leader>s:", function() Snacks.picker.command_history() end, { desc = "Command History" })
vim.keymap.set("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Location List" })
vim.keymap.set("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Undo History" })
vim.keymap.set("n", "<leader>s'", function() Snacks.picker.registers() end, { desc = "Registers" })
vim.keymap.set("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Colorschemes" })

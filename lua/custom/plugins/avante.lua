return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	version = false,
	build = "make",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		{
			"HakonHarnes/img-clip.nvim",
			event = "VeryLazy",
			opts = {
				default = {
					embed_image_as_base64 = false,
					prompt_for_file_name = false,
					drag_and_drop = {
						insert_mode = true,
					},
				},
			},
		},
		{
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
	},
	opts = {
		provider = "copilot",
		behaviour = {
			auto_suggestions = false,
			auto_set_highlight_group = true,
			auto_set_keymaps = true,
			auto_apply_diff_after_generation = false,
			support_paste_from_clipboard = false,
		},
		mappings = {
			diff = {
				ours = "co",
				theirs = "ct",
				all_theirs = "ca",
				both = "cb",
				cursor = "cc",
				next = "]x",
				prev = "[x",
			},
			jump = {
				next = "]]",
				prev = "[[",
			},
			submit = {
				normal = "<CR>",
				insert = "<C-s>",
			},
		},
		hints = { enabled = true },
		windows = {
			position = "right",
			wrap = true,
			width = 30,
			sidebar_header = {
				align = "center",
				rounded = true,
			},
		},
	},
	keys = {
		{ "<leader>aa", function() require("avante.api").ask() end, desc = "Avante: Ask", mode = { "n", "v" } },
		{ "<leader>ar", function() require("avante.api").refresh() end, desc = "Avante: Refresh" },
		{ "<leader>ae", function() require("avante.api").edit() end, desc = "Avante: Edit", mode = "v" },
		{ "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Avante: Toggle" },
		{ "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante: Chat" },
		{ "<leader>aC", "<cmd>AvanteClear<cr>", desc = "Avante: Clear" },
	},
}

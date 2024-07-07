return {
	"prettier/vim-prettier",                                                        -- Plugin repository
	ft = { "javascript", "typescript", "css", "html", "json", "yaml", "markdown", "less" }, -- File types to trigger lazy loading
	config = function()
		-- Plugin configuration
		vim.g["prettier#autoformat"] = 1
		vim.g["prettier#autoformat_require_pragma"] = 0
	end,
	build = "yarn install --frozen-lockfile --production", -- Build command for the plugin
}

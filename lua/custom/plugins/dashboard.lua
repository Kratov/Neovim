return {
	'nvimdev/dashboard-nvim',
	event = 'VimEnter',
	config = function()
		require('dashboard').setup {
			config = {
				shortcut = {
					{
						desc = " Find File          ",
						action = "Telescope find_files",
						key = "f"
					},
					{
						desc = "  Search Text        ",
						action = "Telescope live_grep",
						key = "s"
					},
					{
						desc = "  Recent Files       ",
						action = "Telescope oldfiles",
						key = "r"
					},
					{
						desc = "  Config             ",
						action = "edit ~/.config/nvim/init.lua",
						key = "c"
					}
				},
				header = {
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣴⣶⡶⣶⣶⣦⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⡾⠛⠉⢠⣶⣿⣿⣶⣄⠉⠛⢿⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠋⠀⠀⠀⣿⣿⣿⣿⣿⣿⠀⠀⠀⠙⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⢣⣴⣶⣶⣦⡹⢿⣿⣿⡿⢏⣴⣶⣶⣦⡜⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡏⣿⣿⣿⣿⣿⣿⠀⣿⡿⠀⣿⣿⣿⣿⣿⣿⢸⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⡇⠻⣿⣿⣿⣿⣿⡀⣽⣿⢀⣽⣿⣿⣿⣿⠟⢸⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⡀⠈⠉⠉⠉⠻⣿⣿⣿⣾⠟⠁⠉⠉⠁⠀⣾⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠈⣿⣿⠁⠀⠀⠀⠀⢀⣾⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⣄⠀⠀⠀⣽⣷⠀⠀⠀⣠⣴⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠿⢷⣶⣾⣷⣶⡶⠿⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀]],
					[[⠀⠀⣀⣀⡀⠀⠀⣀⣀⣀⣀⣀⣀⠀⠀⠀⣀⣀⣀⠀⠀⠀⠀⠀⣀⣀⠀⠀⠀⠀⣀⣀⡀⠀⢀⣀⡀⠀⢀⣀⣀⣀⣀⣀⡀⠀⠀]],
					[[⣴⣿⠟⠛⢿⣦⡀⣿⡟⠛⠛⠛⣿⣷⣰⣿⠟⠛⢿⣷⡄⢠⣠⣤⡻⠻⠗⠀⣴⣿⠟⠛⢿⣦⣸⣿⣧⣾⡿⢛⣿⡿⠟⠻⣿⣦⠀]],
					[[⣿⡇⠀⠀⠀⣿⡇⣿⣷⣄⡀⠀⠉⠁⣿⣇⠀⠀⠀⣿⡇⣀⡉⠻⢿⣶⣄⡰⣿⣇⠀⠀⠀⣿⡿⣿⣿⣅⡀⢸⣿⡀⠀⠀⢸⣿⠀]],
					[[⠙⠿⣷⣶⣦⣿⡇⠛⠋⠛⢿⣷⣤⡀⠙⠿⣷⣶⡦⣿⡇⢿⣷⣶⣶⣿⣿⣿⠙⠿⣷⣶⡆⣿⡟⠛⠋⠻⢿⣶⣿⣿⣷⣶⣼⣿⡁]],
				},
				footer = { 'アラサカ社' }
			},
		}
	end,
	dependencies = { { 'nvim-tree/nvim-web-devicons' } }
}

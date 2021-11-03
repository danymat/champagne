require("neorg").setup({
	load = {
		["core.defaults"] = {},
		["core.keybinds"] = {
			config = {
				default_keybinds = true,
				neorg_leader = "<Leader>o",
			},
		},
		["core.norg.concealer"] = {
			config = {
				icon_preset = "diamond",
			},
		}, -- Allows for use of icons
		["core.norg.dirman"] = { -- Manage your directories with Neorg
			config = {
				workspaces = {
					gtd = "~/Documents/000 Meta/00.03 gtd",
					insa = "~/Documents/101 Personnel/40-49 Insa/46 5A/101.46.00 Notes",
				},
			},
		},

		["core.gtd.base"] = {
			config = {
				workspace = "gtd",
				exclude = { "gtd.norg", "neogen.norg", "kenaos.norg"},
			},
		},
		-- ["core.integrations.pandoc"] = {},

		["core.integrations.telescope"] = {},
		["core.norg.completion"] = {
			config = {
				engine = "nvim-cmp",
			},
		},
		["core.norg.qol.toc"] = {},
	},
	-- logger = {
	-- 	level = "info", -- Show trace, info, warning, error and fatal messages
	-- },
})

require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        --["core.ui.calendar"] = {},
        ["core.concealer"] = {},
        --["core.presenter"] = { config = { zen_mode = "zen-mode" } },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    notes = "~/notes",
                },
            },
        }
    }
})

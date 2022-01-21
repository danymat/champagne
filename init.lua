local core = {
	"globals",
	"plugins",
	"configuration",
	"keybinds",
}

pcall(require, "impatient")

for _, module in ipairs(core) do
	local ok, err = pcall(require, module)
	if not ok then
		error("Error loading " .. module .. "\n\n" .. err)
	end
end
-- require('plugins')
-- require('impatient')
-- require('globals')
-- require('configuration')
-- require('configs.lsp')
-- require('keybinds')

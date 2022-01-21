local ok, tailwindcss_colors = Prequire("tailwindcss-colors")

if not ok then return end

tailwindcss_colors.setup()

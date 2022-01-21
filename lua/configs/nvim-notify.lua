local ok, nvim_notify = Prequire("notify")

if not ok then
	return
end

vim.notify = nvim_notify

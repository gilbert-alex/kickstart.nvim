-- file location: ~/.config/nvim/lua/custom/personal.lua

--  PERSONAL: mypy linting via nvim-lint
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })
local lint = require("lint")

lint.linters_by_ft = {
	python = { "mypy" },
}

lint.linters.mypy.cmd = function()
	local venv_mypy = vim.fn.getcwd() .. "/.venv/bin/mypy"
	if vim.fn.executable(venv_mypy) == 1 then
		return venv_mypy
	end
	return "mypy"
end

vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
	callback = function()
		lint.try_lint()
	end,
})

--  PERSONAL: colorscheme
-- Improve float legibility against tokyonight-night.
local colors = require("tokyonight.colors").setup()
vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg_dark, fg = colors.fg })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = colors.bg_dark, fg = colors.blue })

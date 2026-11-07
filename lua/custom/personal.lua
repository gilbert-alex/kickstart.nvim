-- file location: ~/.config/nvim/lua/custom/personal.lua

--  PERSONAL: mypy linting via nvim-lint
vim.pack.add { 'https://github.com/mfussenegger/nvim-lint' }
local lint = require 'lint'

lint.linters_by_ft = {
  python = { 'mypy' },
}

lint.linters.mypy.cmd = function()
  local venv_mypy = vim.fn.getcwd() .. '/.venv/bin/mypy'
  if vim.fn.executable(venv_mypy) == 1 then return venv_mypy end
  return 'mypy'
end

vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
  callback = function() lint.try_lint() end,
})

-- float/popup theming
local function set_float_hl()
  --[[
	`vim.api` offers several interfaces to adjust the assigned values.	

	The `nvim_set_hl` function allows for three positional params:
		namespace id: 0 is global
		highlight group name (groups are created if do not exist)
		an object of attributes to apply

	A group's attributes may be "linked" to another that of another group.
	]]
  local c = require('tokyonight.colors').setup()
  local set = vim.api.nvim_set_hl

  -- base global groups as alias for links to other groups
  set(0, 'NormalFloat', { bg = c.bg_dark, fg = c.fg })
  set(0, 'FloatBorder', { bg = c.bg_dark, fg = c.blue })

  -- blink groups
  for _, g in ipairs {
    'BlinkCmpMenu',
    'BlinkCmpDoc',
    'BlinkCmpSignatureHelp',
  } do
    set(0, g, { link = 'NormalFloat' })
  end
  for _, g in ipairs {
    'BlinkCmpMenuBorder',
    'BlinkCmpDocBorder',
    'BlinkCmpSignatureHelpBorder',
  } do
    set(0, g, { link = 'FloatBorder' })
  end

  -- selected completion items needs to stand out from bg_dark
  set(0, 'BlinkCmpMenuSelection', {
    fg = c.red,
    bg = c.bg_visual,
    bold = true,
  })
end

vim.api.nvim_create_autocmd('ColorScheme', { callback = set_float_hl })
set_float_hl()

-- override blink.cmp defaults
local blink_cfg = require 'blink.cmp.config'
blink_cfg.completion.menu.border = 'rounded'
blink_cfg.completion.documentation.window.border = 'rounded'
blink_cfg.signature.trigger.enabled = false
blink_cfg.signature.window.border = 'rounded'
blink_cfg.signature.window.show_documentation = false

-- TODO add a "Kubectl refresh" buffer-local command that will re-run the command.

local function describe(mods)
	return function()
		require('kubectl.ui_util').describe_resource(nil, nil, mods)
	end
end

vim.api.nvim_buf_set_keymap(0, "n", "<cr>",  "", {callback=describe()})
vim.api.nvim_buf_set_keymap(0, "n", "<c-t>", "", {callback=describe("tab")})
vim.api.nvim_buf_set_keymap(0, "n", "<c-v>", "", {callback=describe("vsplit")})
vim.api.nvim_buf_set_keymap(0, "n", "<c-x>", "", {callback=describe("split")})

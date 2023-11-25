local kube_util = require("kubectl.kube_util")

M = {
	info = {
		supported_commands = {
			'get',
			'describe',
		}
	}
}

function M.cmd(args)
	-- TODO support flags before command, e.g. kubectl --namespace foo get pods
	local cmd = args.fargs[1]

	if (cmd == "describe") then
		M.describe(args)
	elseif (cmd == "get") then
		M.get(args)
	else
		error("Invalid or unsupported kubectl command: " .. cmd)
	end

end

-- Run the window split if a modifier like "vertical" was given
local function do_cmd_mod_split(mods)
	if mods ~= "" then
		vim.cmd(mods .. " split")
	end
end

-- Run a kubectl "get" command and output to a buffer
function M.get(args)
	local kube_resource = kube_util.determine_resource_from_cmd(args.fargs)

	-- TODO see if there's an existing buffer we can re-use
	-- Create the buffer
	local buf = vim.api.nvim_create_buf(true, false)

	-- Display it
	-- vim.api.nvim_command("vsplit")
	do_cmd_mod_split(args.mods)
	vim.api.nvim_win_set_buf(0, buf)

	-- Fill the buffer
	local lines = vim.fn.systemlist("kubectl " .. args.args)
	vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
	vim.api.nvim_command(":normal gg")

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, 'filetype', 'kubectlget')
	vim.api.nvim_buf_set_option(buf, 'modified', false)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'readonly', true)
	vim.api.nvim_buf_set_name(buf, "kubectl " .. args.args)
	vim.api.nvim_buf_set_var(buf, "kube_resource", kube_resource)
end

-- Run a kubectl "describe" command and output to a buffer
function M.describe(args)
	local kube_resource = kube_util.determine_resource_from_cmd(args.fargs)

	-- TODO see if there's an existing buffer we can re-use
	-- Create the buffer
	local buf = vim.api.nvim_create_buf(true, false)

	-- Display it
	-- vim.api.nvim_command("vsplit")
	do_cmd_mod_split(args.mods)
	vim.api.nvim_win_set_buf(0, buf)

	-- Fill the buffer
	local lines = vim.fn.systemlist("kubectl " .. args.args)
	vim.api.nvim_buf_set_lines(buf, 0, 0, false, lines)
	vim.api.nvim_command(":normal gg")

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, 'filetype', 'kubectldescribe')
	vim.api.nvim_buf_set_option(buf, 'modified', false)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'readonly', true)
	-- vim.api.nvim_buf_set_name(buf, cmd_details.class .. "/" .. cmd_details.item)
	vim.api.nvim_buf_set_name(buf, "kubectl " .. args.args)
	vim.api.nvim_buf_set_var(buf, "kube_resource", kube_resource)
end

-- lua require("kubectl").devdebug()
function M.devhook()
	vim.api.nvim_set_keymap("n", "<leader>kk", ":Kubectl describe pods solr-0<cr>", {})
end

return M

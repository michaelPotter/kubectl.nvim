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

-- TODO move to a util file?
local function __parse_describe_cmd(fargs)
	local class = ""
	local item = ""
	-- NOTE: this assumes flags come after command
	for _, value in pairs(fargs) do
		if (value == "describe") then
		elseif class == "" then
			class = value
		elseif item == "" then
			item = value
		else
			break
		end
	end
	return {
		class = class,
		item = item,
	}
end

local function do_cmd_mod_split(mods)
	if mods ~= "" then
		vim.cmd(mods .. " split")
	end
end

function M.get(args)
	-- local cmd_details = __parse_describe_cmd(args.fargs)

	-- Create the buffer
	local buf = vim.api.nvim_create_buf(true, false)

	-- Display it
	-- vim.api.nvim_command("vsplit")
	do_cmd_mod_split(args.mods)
	vim.api.nvim_win_set_buf(0, buf)

	-- Fill the buffer
	vim.api.nvim_command(":r ! kubectl " .. args.args)
	vim.api.nvim_command(":normal ggdd")

	-- Set buffer options
	-- vim.api.nvim_buf_set_option(buf, 'filetype', 'kubectldescribe')
	vim.api.nvim_buf_set_option(buf, 'modified', false)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'readonly', true)
	vim.api.nvim_buf_set_name(buf, "kubectl " .. args.args)
end

function M.describe(args)
	local cmd_details = __parse_describe_cmd(args.fargs)

	-- Create the buffer
	local buf = vim.api.nvim_create_buf(true, false)

	-- Display it
	-- vim.api.nvim_command("vsplit")
	do_cmd_mod_split(args.mods)
	vim.api.nvim_win_set_buf(0, buf)

	-- Fill the buffer
	vim.api.nvim_command(":r ! kubectl " .. args.args)
	vim.api.nvim_command(":normal ggdd")

	-- Set buffer options
	vim.api.nvim_buf_set_option(buf, 'filetype', 'kubectldescribe')
	vim.api.nvim_buf_set_option(buf, 'modified', false)
	vim.api.nvim_buf_set_option(buf, 'modifiable', false)
	vim.api.nvim_buf_set_option(buf, 'readonly', true)
	-- vim.api.nvim_buf_set_name(buf, cmd_details.class .. "/" .. cmd_details.item)
	vim.api.nvim_buf_set_name(buf, "kubectl " .. args.args)
end

-- lua require("kubectl").devdebug()
function M.devdebug()
	vim.api.nvim_set_keymap("n", "<leader>kk", ":Kubectl describe pods solr-0<cr>", {})
	vim.cmd("DoOnWrite Lazy reload kubectl.nvim")
end

return M

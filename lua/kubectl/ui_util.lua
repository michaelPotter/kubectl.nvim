M = {}

-- Run this in a kubectlget buffer, to get the name of the resource under the cursor.
-- Assumes the name is the first field on the line.
function M.get_resource_name()
	local tokens = vim.fn.split(vim.api.nvim_get_current_line())
	return tokens[1]
end

function M.describe_resource(resource_type, name, mods)

	resource_type = resource_type or vim.b.kube_resource
	name = name or M.get_resource_name()

	local fargs = {"describe", resource_type, name}
	local args = {
		args = vim.fn.join(fargs, " "),
		fargs = fargs,
		mods = mods or "",
	}
	require("kubectl").describe(args)

end

return M

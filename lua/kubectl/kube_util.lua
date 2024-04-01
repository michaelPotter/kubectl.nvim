local kube_util = {
	cache = {}
}

function kube_util.get_api_resources()
	if kube_util.cache.api_resources then
		return kube_util.cache.api_resources
	end
	kube_util.cache.api_resources = {}

	local api_resources_raw = vim.fn.systemlist("kubectl api-resources")

	local header_line = api_resources_raw[1]
	table.remove(api_resources_raw, 1)

	local shortname_col, shortname_col_end = string.find(header_line, "SHORTNAMES")
	-- local shortname_col, shortname_col_end = string.find(header_line, "APIVERSION")
	-- local shortname_col, shortname_col_end = string.find(header_line, "NAMESPACED")
	for _, line in pairs(api_resources_raw) do
		local resource = {}
		resource.name = vim.fn.trim(string.sub(line, 1, shortname_col-1))
		local shortname = vim.fn.trim(string.sub(line, shortname_col, shortname_col_end)) or nil
		if shortname ~= "" then resource.shortname = shortname end
		table.insert(kube_util.cache.api_resources, resource)
	end
	return kube_util.cache.api_resources
end

local function is_api_resource(check_name)
	for _, res in pairs(kube_util.get_api_resources()) do
		if check_name == res.name or check_name == res.shortname or check_name .. "s" == res.name then
			return true
		end
	end
	return false
end

function kube_util.determine_resource_from_cmd(fargs)
	for i, arg in pairs(fargs) do
		if is_api_resource(arg) then
			return arg
		end
	end
	return "?"
end

return kube_util


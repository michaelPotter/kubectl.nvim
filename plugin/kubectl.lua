-- command -nargs=+ Kubectl :lua require("kubectl").cmd("<args>")

vim.api.nvim_create_user_command("Kubectl", function(data)
	require("kubectl").cmd(data)
end, {
	nargs = '*',
})

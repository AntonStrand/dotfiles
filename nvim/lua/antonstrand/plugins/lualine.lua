-- LSP STATUS

local function lsp_name()
	local name = "No Active Lsp"
	local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
	local clients = vim.lsp.get_active_clients()
	if next(clients) == nil then
		return name
	end
	for _, client in ipairs(clients) do
		local filetypes = client.config.filetypes
		if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
			return client.name
		end
	end
	return name
end

local function lsp_progress()
	local messages = vim.lsp.util.get_progress_messages()
	if #messages == 0 then
		return
	end
	local status = {}
	status[lsp_name()] = 1
	for _, msg in pairs(messages) do
		-- Ignore "empty title" and duplicate entries
		if msg.title ~= "empty title" then
			if msg.percentage == nil then
				status[(msg.title or "")] = 1
			else
				status[(msg.percentage .. "%% " .. (msg.title or ""))] = 1
			end
		end
	end
	local unique_status = {}
	for title, _ in pairs(status) do
		table.insert(unique_status, title)
	end
	local spinners = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
	local ms = vim.loop.hrtime() / 1000000
	local frame = math.floor(ms / 120) % #spinners
	return table.concat(unique_status, " | ") .. " " .. spinners[frame + 1]
end

local function lsp_status()
	local progress = lsp_progress()
	if progress then
		return progress
	else
		return lsp_name()
	end
end

-- PROJECT DIRECTORY

-- Store the path and directory in a cache to avoid recalculating it
local cache_path = nil
local current_directory = nil

local function get_project_root()
	local cur_path = vim.fn.expand("%:p")

	-- Avoid recalculating the directory if the path hasn't changed
	if cur_path == cache_path then
		return current_directory
	end

	cache_path = cur_path
	current_directory = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")

	-- Find current submodule first
	local git_path = vim.fs.find(".git", {
		path = cur_path,
		upward = true,
		stop = vim.loop.os_homedir(),
	})[1]

	-- Not in a git repo
	if git_path == nil then
		return current_directory
	end

	local git_dir_name = vim.fn.fnamemodify(vim.fs.dirname(git_path), ":t")

	-- Show the name of the current directory instead of .
	if git_dir_name == "." then
		return current_directory
	end

	current_directory = git_dir_name
	return git_dir_name
end

return {
	-- Dependency to show copilot status in lualine.
	{ "AndreM222/copilot-lualine" },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lualine = require("lualine")
			-- to configure lazy pending updates count
			local lazy_status = require("lazy.status")
			local mocha = require("catppuccin.palettes").get_palette("mocha")

			-- configure lualine with modified theme
			lualine.setup({
				options = {
					theme = "catppuccin",
					globalstatus = true,
					component_separators = "",
					section_separators = { left = "", right = "" },
				},
				sections = {
					lualine_a = { "mode" },

					-- Git status
					lualine_b = { "branch", "diff" },

					-- File path and status
					lualine_c = {
						{
							get_project_root,
							icon = " ",
							separator = "",
							color = { fg = mocha.overlay1 },
						},
						{
							"filetype",
							icon_only = true,
							padding = { left = 1, right = 0 },
						},
						{
							"filename",
							file_status = true, -- displays file status (readonly status, modified status)
							path = 0, -- Filename and parent dir, with tilde as the home directory
							symbols = {
								newfile = "", -- Icon to show when the file is new.
								readonly = "", -- Icon to show when the file is read only.
								unnamed = "", -- No icon to show when the file is unnamed.
								modified = "", -- Icon to show when the file is modified.
							},
						},
						"diagnostics",
						{
							function()
								local bufnr = vim.api.nvim_get_current_buf()
								return require("arrow.statusline").text_for_statusline_with_icons(bufnr)
							end,
						},
					},
					lualine_x = {
						{
							"copilot",
							symbols = {
								status = {
									icons = {
										enabled = "",
										sleep = "",
										disabled = "",
										warning = "",
										unknown = "",
									},
									hl = {
										enabled = mocha.green,
										sleep = mocha.green,
										disabled = mocha.overlay0,
										warning = mocha.peach,
										unknown = mocha.red,
									},
								},
								spinners = require("copilot-lualine.spinners").dots,
								spinner_color = mocha.green,
							},
							show_colors = true,
							show_loading = true,
						},
						{
							-- Show number of plugins that needs to be updated if there are any
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = mocha.maroon },
						},
					},
					lualine_y = {
						"filetype",
						{
							-- Show the current lsp status
							icon = "",
							lsp_status,
						},
						"progress",
					},
				},
			})
		end,
	},
}

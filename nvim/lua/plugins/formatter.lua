local priotizedFormatter = { "biome", "prettier", stop_after_first = true }

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true }, function(err, did_edit)
					if not err and did_edit then
						vim.notify("Code formatted", vim.log.levels.INFO, { title = "Conform" })
					elseif err then
						vim.notify("Code formatting failed", vim.log.levels.ERROR, { title = "Conform" })
					end
				end)
			end,
			mode = "",
			desc = "[F]ormat buffer async",
		},
	},
	opts = {
		notify_on_error = true,
		formatters_by_ft = {
			lua = { "stylua" },
			elm = { "elm_format" },
			markdown = { "prettier" },
			html = priotizedFormatter,
			json = priotizedFormatter,
			yaml = priotizedFormatter,
			css = priotizedFormatter,
			javascript = priotizedFormatter,
			typescript = priotizedFormatter,
			javascriptreact = priotizedFormatter,
			typescriptreact = priotizedFormatter,
			sh = { "shfmt" },
		},
		format_on_save = {
			timeout_ms = 1000,
			lsp_format = "fallback",
		},
	},
}

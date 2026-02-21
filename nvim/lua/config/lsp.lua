local servers = {
	"clangd",
	"elmls",
	"html",
	"lua_ls",
	"tailwindcss",
	"ts_ls",
}

-- TODO: this should be in it's own file
vim.lsp.config("tailwindcss", {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"elm",
		"html",
		"php",
		"css",
		"javascript",
		"typescript",
	},
	root_markers = { ".git" },
	capabilities = {
		workspace = {
			didChangeWatchedFiles = {
				dynamicRegistration = true,
			},
		},
	},
	settings = {
		tailwindCSS = {
			includeLanguages = {
				elm = "html",
				html = "html",
			},
			classAttributes = { "class", "className", "classList", "ngClass" },
			experimental = {
				classRegex = {
					'\\bclass[\\s(<|]+"([^"]*)"',
					'\\bclass[\\s(]+"[^"]*"[\\s+]+"([^"]*)"',
					'\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
					'\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
					'\\bclass[\\s<|]+"[^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" [^"]*"\\s*\\+{2}\\s*" ([^"]*)"',
					'\\bclassList[\\s\\[\\(]+"([^"]*)"',
					'\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
					'\\bclassList[\\s\\[\\(]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"[^"]*",\\s[^\\)]+\\)[\\s\\[\\(,]+"([^"]*)"',
				},
			},
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			validate = true,
		},
	},
})

vim.lsp.enable(servers)

local keymap = vim.keymap -- for conciseness
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf, silent = true }

		-- set keybinds
		opts.desc = "Show LSP references"
		keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)

		opts.desc = "Go to declaration"
		keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

		opts.desc = "Show LSP definition"
		keymap.set("n", "gd", vim.lsp.buf.definition, opts)

		opts.desc = "Show LSP implementations"
		keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

		opts.desc = "Show LSP type definitions"
		keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

		opts.desc = "See available code actions"
		keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

		opts.desc = "Smart rename"
		keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

		opts.desc = "Show documentation for what is under cursor"
		keymap.set("n", "K", vim.lsp.buf.hover, opts)

		opts.desc = "Restart LSP"
		keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
	end,
})

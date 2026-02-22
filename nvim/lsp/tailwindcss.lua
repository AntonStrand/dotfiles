return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = {
		"elm",
		"html",
		"php",
		"css",
		"javascript",
		"typescript",
	},
	root_dir = function(bufnr, on_dir)
		local util = require("lspconfig.util")
		local root_files = {
			-- Generic
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tailwind.config.ts",
			-- Fallback for tailwind v4, where tailwind.config.* is not required anymore
			".git",
		}
		local fname = vim.api.nvim_buf_get_name(bufnr)
		root_files = util.insert_package_json(root_files, "tailwindcss", fname)
		root_files = util.root_markers_with_field(root_files, { "mix.lock", "Gemfile.lock" }, "tailwind", fname)
		on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
	end,
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
}

local delimiter = "\t\t"

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", string.format("%s.*$", delimiter))
      vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

local function filenameFirst(_, path)
  local tail = vim.fs.basename(path)
  if parent == "." then
    return tail
  end
  return string.format("%s%s%s", tail, delimiter, parent)
	local parent = vim.fn.fnamemodify(vim.fs.dirname(path), ":p:~:.")
end

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = filenameFirst,
        mappings = {
          i = {                                    -- Insert mode
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-p>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-n>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          },
          n = {
            ["dd"] = actions.delete_buffer,
            ["q"] = actions.close,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    vim.keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    vim.keymap.set(
      "n",
      "<leader>fb",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true initial_mode=normal theme=ivy<cr>",
      { desc = "Open buffers" }
    )
    vim.keymap.set(
      "n",
      "<leader>fc",
      "<cmd>Telescope grep_string<cr>",
      { desc = "Find string under cursor in cwd" }
    )
    vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Find help" })
    vim.keymap.set("n", "<leader>fq", "<cmd>Telescope registers<cr>", { desc = "Open registers" })

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>fif", function()
      builtin.find_files({ prompt_title = "Find Insurello file", cwd = "~/work/insurello/" })
    end, { desc = "Find files in insurello" })

    vim.keymap.set("n", "<leader>fis", function()
      builtin.live_grep({ prompt_title = "Find in Insurello files", cwd = "~/work/insurello/" })
    end, { desc = "Find string in insurello" })

    vim.keymap.set("n", "<leader>fd", function()
      builtin.live_grep({ prompt_title = "Search Neovim tips and tricks", cwd = "~/notes/neovim/" })
    end, { desc = "Search Neovim tips and tricks" })
  end,
}

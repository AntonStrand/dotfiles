return {
  "backdround/global-note.nvim",
  config = function()
    local global_note = require("global-note")

    global_note.setup({
      filename = "global.md",
      directory = "~/notes/",

      window_config = function()
        local window_height = vim.api.nvim_list_uis()[1].height
        local window_width = vim.api.nvim_list_uis()[1].width
        return {
          relative = "editor",
          border = "rounded",
          title = "Note",
          title_pos = "center",
          width = math.floor(0.7 * window_width),
          height = math.floor(0.85 * window_height),
          row = math.floor(0.05 * window_height),
          col = math.floor(0.15 * window_width),
        }
      end,

      -- Close window with "q" key.
      post_open = function(buffer_id, _)
        vim.opt.spell = true
        vim.opt.wrap = true

        vim.keymap.set({ "n", "v" }, "q", "<Cmd>quit<Cr>", {
          buffer = buffer_id,
          noremap = true,
          silent = true,
          desc = "Close the window",
        })

        vim.keymap.set("n", "<leader>e", function()
          -- Enable q key to act as usual again.
          vim.keymap.del({ "n", "v" }, "q", { buffer = buffer_id })

          -- Close the floating window and open the note in a new window.
          vim.cmd(":quit | edit " .. vim.fn.expand("%:p"))
        end, {
          buffer = buffer_id,
          noremap = true,
          silent = true,
          desc = "[e]dit note in a new window",
        })
      end,

      additional_presets = {
        todos = {
          filename = "projects-to-do.md",
          title = " To do ",
          command_name = "ProjectsNote",
          -- All not specified options are used from the root.
        },
        nvim = {
          filename = "nvim.md",
          title = " Neovim improvements ",
          command_name = "NvimNote",
        },
        one_on_one = {
          filename = "1-1.md",
          title = " 1 - 1 ",
          command_name = "OneNote",
        },
        sketch_book = {
          filename = "sketch-book.md",
          title = " Sketch book ",
          command_name = "SketchBook",
        },
      },
    })

    vim.keymap.set("n", "<leader>ng", global_note.toggle_note, {
      desc = "Toggle global note",
    })

    vim.keymap.set("n", "<leader>np", function()
      global_note.toggle_note("todos")
    end, {
      desc = "Toggle projects note",
    })

    vim.keymap.set("n", "<leader>no", function()
      global_note.toggle_note("one_on_one")
    end, {
      desc = "Toggle 1-1 note",
    })

    vim.keymap.set("n", "<leader>ni", function()
      global_note.toggle_note("nvim")
    end, {
      desc = "Toggle Neovim note",
    })

    vim.keymap.set("n", "<leader>ns", function()
      global_note.toggle_note("sketch_book")
    end, {
      desc = "Toggle sketch book",
    })
  end,
}

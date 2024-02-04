return {
  {
    "gelguy/wilder.nvim",
    event = "VeryLazy",
    keys = {
      ":",
      "/",
      "?",
    },
    dependencies = {
      "catppuccin/nvim",
    },
    config = function()
      local wilder = require("wilder")
      local mocha = require("catppuccin.palettes").get_palette("mocha")

      -- Create a highlight group for the popup menu
      local highlight = function(id, color)
        return wilder.make_hl(id, { { a = 1 }, { a = 1 }, { foreground = color } })
      end

      local text_highlight = highlight("WilderText", mocha.text)
      local blue_highlight = highlight("WilderBlue", mocha.blue)
      local mauve_highlight = highlight("WilderMauve", mocha.mauve)

      -- Enable wilder when pressing :, / or ?
      wilder.setup({
        modes = { ":", "/", "?" },
        next_key = "<C-j>",
        previous_key = "<C-k>",
        accept_key = "<C-l>",
        reject_key = "<C-h>",
      })

      -- Enable fuzzy matching for commands and buffers
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline({
            fuzzy = 1,
          }),
          wilder.vim_search_pipeline({
            fuzzy = 1,
          })
        ),
      })

      wilder.set_option(
        "renderer",
        wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
          highlighter = wilder.basic_highlighter(),
          highlights = {
            default = text_highlight,
            border = blue_highlight,
            accent = mauve_highlight,
          },
          -- pumblend = 5,
          min_width = "100%",
          -- min_height = "25%",
          max_height = "25%",
          border = "rounded",
          left = { " ", wilder.popupmenu_devicons() },
          right = { " ", wilder.popupmenu_scrollbar() },
        }))
      )
    end,
  },
}

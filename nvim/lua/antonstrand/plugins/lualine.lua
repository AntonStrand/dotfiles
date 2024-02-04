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
        },
        sections = {
          lualine_c = {
            {
              "filename",
              file_status = true, -- displays file status (readonly status, modified status)
            },
            { require("arrow.statusline").text_for_statusline_with_icons },
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
            "encoding",
            "filetype",
          },
        },
      })
    end,
  },
}

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

    local colors = {
      blue = "#65D1FF",
      green = "#3EFFDC",
      violet = "#FF61EF",
      yellow = "#FFDA7B",
      red = "#FF4A4A",
      fg = "#c3ccdc",
      bg = "#112638",
      inactive_bg = "#2c3043",
    }

    local custom_lualine_theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      insert = {
        a = { bg = colors.green, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      visual = {
        a = { bg = colors.violet, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      command = {
        a = { bg = colors.yellow, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      replace = {
        a = { bg = colors.red, fg = colors.bg, gui = "bold" },
        b = { bg = colors.bg, fg = colors.fg },
        c = { bg = colors.bg, fg = colors.fg },
      },
      inactive = {
        a = { bg = colors.inactive_bg, fg = colors.semilightgray, gui = "bold" },
        b = { bg = colors.inactive_bg, fg = colors.semilightgray },
        c = { bg = colors.inactive_bg, fg = colors.semilightgray },
      },
    }

    -- configure lualine with modified theme
    lualine.setup({
      options = {
        theme = custom_lualine_theme,
      },
      sections = {
        lualine_x = {
          {
            -- Show number of plugins that needs to be updated if there are any
            lazy_status.updates,
            cond = lazy_status.has_updates,
            color = { fg = "#ff9e64" },
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

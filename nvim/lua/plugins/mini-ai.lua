return {
  "echasnovski/mini.ai",
  version = "*",
  config = function()
    require("mini.ai").setup({
      custom_textobjects = {
        -- Disable function alias
        f = false,
        -- Disable argument alias
        a = false,
      },
    })
  end,
}

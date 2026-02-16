return {
  "tpope/vim-projectionist",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  keys = function(_, _)
    return { { "<Leader>ä", "<CMD>A<CR>", mode = "n", desc = "[ä]lternative file" } }
  end,
  opts = {
    ["*"] = {
      -- C
      ["*.c"] = {
        alternate = "{}.h",
      },
      ["*.h"] = {
        alternate = "{}.c",
      },

      -- Elm
      ["app/elm/App/*Service.elm"] = {
        alternate = "app/elm/App/{}.elm",
      },
      ["app/elm/App/Pages/*.elm"] = {
        alternate = "app/elm/App/Pages/{}Service.elm",
      },
    },
  },
  config = function(_, opts)
    vim.g.projectionist_heuristics = opts
  end,
}

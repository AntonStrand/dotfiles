return {
  "nvzone/typr",
  dependencies = "nvzone/volt",
  opts = {
    winlayout = "responsive",
    kblayout = {
      { "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" },
      { "a", "s", "d", "f", "g", "h", "j", "k", "l", ";" },
      { "z", "x", "c", "v", "b", "n", "m", ",", ".", "/" },
    },
    wpm_goal = 120,
    numbers = false,
    symbols = false,
    random = false,
    insert_on_start = false,
    stats_filepath = vim.fn.stdpath("cache") .. "/typrstats",
    mappings = nil,
  },
  cmd = { "Typr", "TyprStats" },
}

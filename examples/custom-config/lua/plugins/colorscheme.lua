-- Custom colorscheme configuration
-- This file is automatically loaded by LazyVim

return {
  -- Configure LazyVim to load tokyonight
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },

  -- Change tokyonight options
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "night", -- storm, night, or moon
      transparent = false,
      terminal_colors = true,
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
      },
    },
  },
}

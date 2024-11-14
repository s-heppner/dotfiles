-- Icons in Neovim
-- See: https://github.com/nvim-tree/nvim-web-devicons
return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,  -- Load the plugin only when required
  config = function()
    require("nvim-web-devicons").setup {
      -- Your configuration options here
      -- For example, to override specific icons:
      override = {
        zsh = {
          icon = "",
          color = "#428850",
          cterm_color = "65",
          name = "Zsh"
        },
      },
      -- Globally enable different highlight colors per icon (default to true)
      color_icons = true,
      -- Globally enable default icons (default to false)
      default = true,
      -- Set the light or dark variant manually
      -- variant = "light",
    }
  end,
}

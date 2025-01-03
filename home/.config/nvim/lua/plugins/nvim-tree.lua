-- Configuration for the tree view plugin
-- See: https://github.com/nvim-tree/nvim-tree.lua
return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      hijack_unnamed_buffer_when_opening = true,
      hijack_netrw = true, --Disable netrw and use NvimTree instead
      filters = {
        dotfiles = false,
      },
    }
  end,
}

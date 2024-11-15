-- Configuration for the Lazy Package Manager
require("config.lazy")

-- Set the font
vim.o.guifont = "JetBrainsMono Nerd"

-- Automatically open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})
-- Create an alias for :NvimTreeToggle
vim.api.nvim_create_user_command("tree", ":NvimTreeToggle", {})

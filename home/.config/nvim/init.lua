-- Configuration for the Lazy Package Manager
require("config.lazy")

-- Set the font
vim.o.guifont = "JetBrainsMono Nerd"

-- Show absolute line number on the current line
vim.opt.number = true
-- Show relative line numbers for other lines    
vim.opt.relativenumber = true

-- Automatically open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    require("nvim-tree.api").tree.open()
  end,
})
-- Create an alias for :NvimTreeToggle
vim.api.nvim_create_user_command("Tree", ":NvimTreeToggle", {})

-- Add vertical lines to the editor
vim.opt.colorcolumn = "50,72"
-- vim.cmd([[highlight ColorColumn ctermbg=lightgrey guibg=lightgrey]])

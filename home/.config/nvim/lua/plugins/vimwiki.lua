-- Configuration for vimwiki
-- See: https://github.com/vimwiki/vimwiki
return {
  "vimwiki/vimwiki",
  lazy = false,  -- Load on startup
  config = function()
    -- Configure Vimwiki
    vim.g.vimwiki_list = {
      {
        path = '~/vimwiki/',  -- Change this to your desired wiki location
        syntax = 'markdown', -- Use markdown syntax
        ext = '.md',         -- Use .md file extension
      }
    }
    vim.g.vimwiki_global_ext = 0 -- Only use configured extensions
  end,
}
-- Configuration for vimwiki
-- See: https://github.com/vimwiki/vimwiki
return {
  "vimwiki/vimwiki",
  lazy = false,  -- Load on startup
  config = function()
    -- Configure Vimwiki
    vim.g.vimwiki_list = {
      {
        path = '~/workspace/wiki/wiki/',
        syntax = 'markdown',
        ext = '.md',
      }
    }
    vim.g.vimwiki_global_ext = 0 -- Only use configured extensions
  end,
}


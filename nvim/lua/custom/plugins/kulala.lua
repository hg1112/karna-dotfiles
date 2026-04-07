---@module 'lazy'
---@type LazySpec
return {
  'mistweaverco/kulala.nvim',
  ft = { 'http' },
  keys = {
    { '<leader>hs', function() require('kulala').run() end, desc = '[H]ttp [S]end request' },
    { '<leader>ha', function() require('kulala').run_all() end, desc = '[H]ttp run [A]ll' },
    { '<leader>hn', function() require('kulala').jump_next() end, desc = '[H]ttp [N]ext request' },
    { '<leader>hp', function() require('kulala').jump_prev() end, desc = '[H]ttp [P]rev request' },
    { '<leader>hi', function() require('kulala').inspect() end, desc = '[H]ttp [I]nspect' },
    { '<leader>hc', function() require('kulala').copy() end, desc = '[H]ttp [C]opy as curl' },
  },
  opts = {
    -- Show response in a vsplit
    default_view = 'body',
    -- Display response headers alongside body
    display_mode = 'split',
    split_direction = 'vertical',
  },
}

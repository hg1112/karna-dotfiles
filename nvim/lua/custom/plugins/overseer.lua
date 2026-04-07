---@module 'lazy'
---@type LazySpec
return {
  'stevearc/overseer.nvim',
  cmd = { 'OverseerRun', 'OverseerToggle', 'OverseerInfo' },
  keys = {
    { '<leader>tr', '<cmd>OverseerRun<cr>', desc = '[T]ask [R]un' },
    { '<leader>tt', '<cmd>OverseerToggle<cr>', desc = '[T]ask [T]oggle panel' },
    { '<leader>tl', '<cmd>OverseerLoadBundle<cr>', desc = '[T]ask [L]oad bundle' },
  },
  opts = {
    -- Store task history between sessions
    task_list = {
      direction = 'bottom',
      min_height = 12,
      max_height = 20,
    },
    -- Templates are discovered from .overseer.json / overseer/ dirs in project root
    templates = { 'builtin' },
  },
}

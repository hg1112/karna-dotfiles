---@module 'lazy'
---@type LazySpec
return {
  'kdheepak/lazygit.nvim',
  cmd = { 'LazyGit', 'LazyGitConfig', 'LazyGitFilter' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  keys = {
    { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'Lazy[G]it' },
    { '<leader>gf', '<cmd>LazyGitFilter<cr>', desc = 'Lazy[G]it file log' },
  },
}

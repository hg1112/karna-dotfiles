return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  ft = { 'markdown' },
  opts = {
    enabled = true,
    -- Render in normal mode only; disable in insert so you can see raw syntax while typing
    render_modes = { 'n', 'c' },
    heading = {
      enabled = true,
      sign = false,     -- set true if you want a sign-column icon
    },
    code = {
      enabled = true,
      style = 'full',   -- 'full' | 'normal' | 'language' | 'none'
    },
    bullet = {
      enabled = true,
    },
    checkbox = {
      enabled = true,   -- renders [ ] and [x] as actual checkboxes
    },
    table = {
      enabled = true,
    },
    link = {
      enabled = true,
    },
  },
}

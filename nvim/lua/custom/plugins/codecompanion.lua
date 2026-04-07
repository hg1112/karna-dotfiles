return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    adapters = {
      anthropic = function()
        return require('codecompanion.adapters').extend('anthropic', {
          env = {
            api_key = 'ANTHROPIC_API_KEY',
          },
        })
      end,
      gemini = function()
        return require('codecompanion.adapters').extend('gemini', {
          env = {
            api_key = 'GEMINI_API_KEY',
          },
        })
      end,
    },
    strategies = {
      chat = { adapter = 'anthropic' },
      inline = { adapter = 'anthropic' },
    },
  },
  keys = {
    { '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', desc = '[A]I [C]hat' },
    { '<leader>ai', '<cmd>CodeCompanion<cr>',           desc = '[A]I [I]nline' },
    { '<leader>aa', '<cmd>CodeCompanionActions<cr>',    desc = '[A]I [A]ctions' },
  },
}

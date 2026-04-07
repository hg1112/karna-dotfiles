---@module 'lazy'
---@type LazySpec
return {
  'nvim-orgmode/orgmode',
  ft = { 'org' },
  event = 'VeryLazy',
  dependencies = {
    -- Better org bullet/heading UI (optional but nice)
    { 'lukas-reineke/headlines.nvim', opts = {} },
  },
  config = function()
    require('orgmode').setup {
      org_agenda_files = '~/org/**/*',
      org_default_notes_file = '~/org/inbox.org',
      -- Capture templates — quick entry without leaving current buffer
      org_capture_templates = {
        t = {
          description = 'Task',
          template = '* TODO %?\n  %U',
          target = '~/org/tasks.org',
        },
        n = {
          description = 'Note',
          template = '* %?\n  %U',
          target = '~/org/notes.org',
        },
        j = {
          description = 'Journal',
          template = '* %<%Y-%m-%d %A>\n** %?\n',
          target = '~/org/journal.org',
        },
      },
    }
  end,
  keys = {
    { '<leader>oa', '<cmd>lua require("orgmode").action("agenda.prompt")<cr>', desc = '[O]rg [A]genda' },
    { '<leader>oc', '<cmd>lua require("orgmode").action("capture.prompt")<cr>', desc = '[O]rg [C]apture' },
  },
}

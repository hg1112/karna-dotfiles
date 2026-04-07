-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

---@module 'lazy'
---@type LazySpec
return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', '<cmd>Neotree toggle<cr>', desc = 'Toggle file tree', silent = true },
    { '<leader>e', '<cmd>Neotree reveal<cr>', desc = '[E]xplorer reveal file', silent = true },
    { '<leader>eb', '<cmd>Neotree buffers reveal float<cr>', desc = '[E]xplorer [B]uffers', silent = true },
    { '<leader>eg', '<cmd>Neotree git_status reveal float<cr>', desc = '[E]xplorer [G]it status', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    filesystem = {
      filtered_items = {
        hide_dotfiles = false, -- show dotfiles
        hide_gitignored = false,
      },
      window = {
        width = 35,
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    window = {
      position = 'left',
      mappings = {
        -- Open a terminal cd'd into the highlighted node's directory
        ['t'] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type == 'file' then
            path = vim.fn.fnamemodify(path, ':h')
          end
          require('toggleterm.terminal').Terminal
            :new({ dir = path, direction = 'horizontal', close_on_exit = false })
            :toggle()
        end,
        ['T'] = function(state)
          local node = state.tree:get_node()
          local path = node:get_id()
          if node.type == 'file' then
            path = vim.fn.fnamemodify(path, ':h')
          end
          require('toggleterm.terminal').Terminal
            :new({ dir = path, direction = 'float', close_on_exit = false })
            :toggle()
        end,
      },
    },
  },
}

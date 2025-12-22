-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  cmd = 'Neotree', -- lazy-load ONLY when command is used
  keys = {
    { '<leader>e', '<cmd>Neotree toggle<cr>', desc = 'Toggle Neo-tree' },
  },
  config = function()
    require('neo-tree').setup {
      close_if_last_window = true,
      filesystem = {
        follow_current_file = {
          enabled = true,
        },
        -- hijack_netrw_behavior = 'disabled', -- important
      },
    }
  end,
}

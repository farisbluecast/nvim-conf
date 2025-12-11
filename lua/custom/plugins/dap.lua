return {
  {
    'mfussenegger/nvim-dap',
    lazy = false,
    config = function()
      -- Key Maps --
      vim.keymap.set('n', '<leader>bb', require('dap').toggle_breakpoint, { noremap = true, desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>bB', function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { noremap = true, desc = 'Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>bc', require('dap').continue, { noremap = true, desc = 'Continue/Start' })
      vim.keymap.set('n', '<leader>bo', require('dap').step_over, { noremap = true, desc = 'Step Over' })
      vim.keymap.set('n', '<leader>bi', require('dap').step_into, { noremap = true, desc = 'Step Into' })

      vim.keymap.set('n', '<leader>bw', function()
        local widgets = require 'dap.ui.widgets'
        widgets.hover()
      end, { desc = 'Show widget' })

      vim.keymap.set('n', '<leader>bf', function()
        local widgets = require 'dap.ui.widgets'
        widgets.centered_float(widgets.frames)
      end, { desc = 'Show stack frames' })

      -- ADAPTERS

      -- Node adapter
      require('dap').adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { '/home/developer/.config/nvim/modules/js-debug-dap-v1.105.0/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }
    end,
  },
}

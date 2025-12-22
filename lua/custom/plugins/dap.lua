local adapters_path = vim.fn.stdpath 'config' .. '/modules'

return {
  { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' } },
  {
    'mfussenegger/nvim-dap',
    lazy = false,
    build = function()
      local js_debug_path = adapters_path .. '/js-debug'

      vim.fn.mkdir(adapters_path, 'p')

      if vim.fn.isdirectory(js_debug_path) == 0 then
        vim.fn.system {
          'bash',
          '-c',
          string.format(
            [[
              cd %s &&
              curl -L https://github.com/microsoft/vscode-js-debug/releases/download/v1.105.0/js-debug-dap-v1.105.0.tar.gz |
              tar -xz
            ]],
            adapters_path
          ),
        }
      end
    end,

    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      local opts = { noremap = true, silent = true }

      vim.keymap.set('n', '<Down>', dap.step_into, opts)
      vim.keymap.set('n', '<Right>', dap.step_over, opts)
      vim.keymap.set('n', '<Left>', dap.restart_frame, opts)
      vim.keymap.set('n', '<Up>', dap.step_out, opts)

      vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { noremap = true, desc = 'Toggle Breakpoint' })
      vim.keymap.set('n', '<leader>bB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { noremap = true, desc = 'Conditional Breakpoint' })
      vim.keymap.set('n', '<leader>bc', dapui.close, { noremap = true, desc = 'Close Dap UI' })
      vim.keymap.set('n', '<leader>bo', dapui.open, { noremap = true, desc = 'Open Dap UI' })
      vim.keymap.set('n', '<leader>bs', dap.continue, { noremap = true, desc = 'Continue/Start' })

      -- ADAPTERS

      -- Node adapter
      dap.adapters['pwa-node'] = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = {
            adapters_path .. '/js-debug/src/dapDebugServer.js',
            '${port}',
          },
        },
      }
    end,
  },
}

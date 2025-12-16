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
      --   local chrome_path = adapters_path .. '/vscode-chrome-debug'
      --   if vim.fn.isdirectory(chrome_path) == 0 then
      --     vim.fn.system {
      --       'bash',
      --       '-c',
      --       string.format(
      --         [[
      --           cd %s &&
      --           git clone https://github.com/Microsoft/vscode-chrome-debug &&
      --           cd vscode-chrome-debug &&
      --           npm install &&
      --           npm run build
      --         ]],
      --         adapters_path
      --       ),
      --     }
      --   end
    end,

    config = function()
      local dap, dapui = require 'dap', require 'dapui'
      dapui.setup()

      -- helper to map keys buffer-locally
      local function set_debug_keymaps()
        local opts = { noremap = true, silent = true }

        vim.keymap.set('n', '<Down>', dap.step_into, opts)
        vim.keymap.set('n', '<Right>', dap.step_over, opts)
        vim.keymap.set('n', '<Left>', dap.restart_frame, opts)
        vim.keymap.set('n', '<Up>', dap.step_out, opts)
      end

      local function clear_debug_keymaps()
        vim.keymap.del('n', '<Down>')
        vim.keymap.del('n', '<Right>')
        vim.keymap.del('n', '<Left>')
        vim.keymap.del('n', '<Up>')
      end

      -- enable when session starts
      dap.listeners.after.event_initialized['arrow-debug'] = function()
        set_debug_keymaps()
      end

      -- disable when session ends
      dap.listeners.before.event_terminated['arrow-debug'] = function()
        clear_debug_keymaps()
      end

      dap.listeners.before.event_exited['arrow-debug'] = function()
        clear_debug_keymaps()
      end
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

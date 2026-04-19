-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    -- 'leoluz/nvim-dap-go',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        -- 'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>db', dap.continue, { desc = 'Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug: Step [i]nto' })
    vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug: Step [o]ver' })
    vim.keymap.set('n', '<leader>dO', dap.step_out, { desc = 'Debug: Step [O]ut' })
    vim.keymap.set('n', '<leader>dx', dap.terminate, { desc = 'Debug: Stop' })
    vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<leader>B', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = 'Debug: Set Breakpoint' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    }

    -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
    vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = 'Debug: [T]oggle the ui' })

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open

    -- Don't automatically exit when debugger finishes
    -- Uncomment to turn back on
    -- dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    -- dap.listeners.before.event_exited['dapui_config'] = dapui.close

    dap.adapters.python = function(callback, _)
      local cwd = vim.fn.getcwd()
      local venv_python = cwd .. '/bin/python'

      if vim.fn.executable(venv_python) == 1 then
        callback {
          type = 'executable',
          command = venv_python,
          args = { '-m', 'debugpy.adapter' },
        }
      else
        -- Fallback to system python if no virtualenv is found
        callback {
          type = 'executable',
          command = 'python3',
          args = { '-m', 'debugpy.adapter' },
        }
      end
    end

    -- dap.adapters.python = {
    --   type = 'executable',
    --   command = '/opt/homebrew/opt/python@3.8/bin/python3.8',
    --   args = { '-m', 'debugpy.adapter' },
    -- }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Run Current File',
        program = '${file}',
        console = 'integratedTerminal',
      },
    }

    if vim.fn.getcwd():find 'edmod%-api' then
      table.insert(dap.configurations.python, {
        type = 'python',
        request = 'launch',
        name = 'Run Django Management Command',
        program = '${workspaceFolder}/manage.py',
        args = function()
          local input = vim.fn.input 'Management command and args: '
          return vim.split(input, ' ')
        end,
        django = true,
      })
    end

    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = '${port}',
      executable = {
        command = 'node',
        -- Update this path if you ever change computers
        args = { '/Users/tonydacoder/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
      },
    }

    dap.configurations.javascript = {
      {
        type = 'pwa-node',
        request = 'launch',
        name = 'Launch File',
        program = '${file}',
        cwd = '${workspaceFolder}',
      },
    }
  end,
}

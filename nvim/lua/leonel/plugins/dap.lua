return {
  'rcarriga/nvim-dap-ui',-- UI for nvim-dap
  dependencies = {
    'mfussenegger/nvim-dap',-- Debug Adapter protocol
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    dap.adapters.godot = {
      type = "server",
      host = '127.0.0.1',
      port = 6006,
    }

    dap.configurations.gdscript = {
      {
        type = "godot",
        request = "launch",
        name = "Launch scene",
        project = "${workspaceFolder}",
        launch_scene = true,
      }
    }

    dap.adapters.coreclr = {
      type = 'executable',
      command = 'netcoredbg',
      args = {'--interpreter=vscode'}
    }

    dap.configurations.cs = {
      {
        type = "godot",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = "${port}",
      executable = {
        command = '/usr/bin/codelldb',
        args = {"--port", "${port}"},
      }
    }

    dap.configurations.c = {
      {
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd()..'/', 'file')
        end,
        --program = '${fileDirname}/${fileBasenameNoExtension}',
        cwd = '${workspaceFolder}',
        terminal = 'integrated'
      }
    }

    dap.configurations.cpp = dap.configurations.c

    dap.configurations.rust = {
      {
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
        end,
        cwd = '${workspaceFolder}',
        terminal = 'integrated',
        sourceLanguages = { 'rust' },
        name = "Run file"
      },
      {
        type = "codelldb",
        request = "launch",
        name = "Debug test",
        cargo = {
          args = {"test", "--no-run",},
          filter = {
            name = "libthat",
            kind = "lib"
          },
        },
        args = {"$selectedText"},
        cwd = "${workspaceFolder}"
      },
    }

    dapui.setup()


    vim.keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>")
    vim.keymap.set("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>")
    vim.keymap.set("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>")
    vim.keymap.set("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>")
    vim.keymap.set("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>")
    vim.keymap.set("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
    vim.keymap.set("n", "<Leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
    vim.keymap.set("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>")
    vim.keymap.set("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>")

  end
}

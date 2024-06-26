return {
  'rcarriga/nvim-dap-ui',-- UI for nvim-dap
  dependencies = {
    'mfussenegger/nvim-dap',-- Debug Adapter protocol
    'theHamsta/nvim-dap-virtual-text',-- Show DAP messages in virtual text
    'nvim-telescope/telescope-dap.nvim',-- Telescope integration for nvim-dap', 
    'nvim-neotest/nvim-nio',
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

    vim.g.dotnet_build_project = function()
      local default_path = vim.fn.getcwd() .. '/'
      if vim.g['dotnet_last_proj_path'] ~= nil then
        default_path = vim.g['dotnet_last_proj_path']
      end
      local path = vim.fn.input('Path to your *proj file', default_path, 'file')
      vim.g['dotnet_last_proj_path'] = path
      local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
      print('')
      print('Cmd to execute: ' .. cmd)
      local f = os.execute(cmd)
      if f == 0 then
        print('\nBuild: ✔️ ')
      else
        print('\nBuild: ❌ (code: ' .. f .. ')')
      end
    end

    vim.g.dotnet_get_dll_path = function()
      local request = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end

      if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
      else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
          vim.g['dotnet_last_dll_path'] = request()
        end
      end

      return vim.g['dotnet_last_dll_path']
    end

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        program = function()
          if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
            vim.g.dotnet_build_project()
          end
          return vim.g.dotnet_get_dll_path()
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = false,
        args = {"--path", "${workspaceFolder}"},
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

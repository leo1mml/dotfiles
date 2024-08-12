-- Gitsigns
-- See `:help gitsigns.txt`
return {
  'lewis6991/gitsigns.nvim',
  config = function()
    local gitsigns = require('gitsigns')
    gitsigns.setup {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    }
  end,
  keys = {
    { "<Leader>nt", "<cmd>Neorg journal today<cr>" },
    { "<Leader>nC", "<cmd>Neorg journal custom<cr>" },
    { '<leader>gs', "<cmd>Gitsigns stage_hunk<cr>" },
    { '<leader>gr', "<cmd>Gitsigns reset_hunk<cr>" },
    {
      '<leader>gs',
      function()
        require('gitsigns').stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
      end,
      mode = 'v'
    },
    {
      '<leader>gr',
      function()
        require('gitsigns').reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
      end,
      mode = 'v'
    },
    { '<leader>gS', "<cmd>Gitsigns stage_buffer<cr>" },
    { '<leader>gu', "<cmd>Gitsigns undo_stage_hunk<cr>" },
    { '<leader>gR', "<cmd>Gitsigns reset_buffer<cr>" },
    { '<leader>gp', "<cmd>Gitsigns preview_hunk<cr>" },
    { '<leader>gb',
      function()
        require('gitsigns').blame_line { full = true }
      end
    },
    { '<leader>gb', "<cmd>Gitsigns toggle_current_line_blame<cr>" },
    { '<leader>gd', "<cmd>Gitsigns diffthis<cr>" },
    { '<leader>gD',
      function()
        require('gitsigns').diffthis('~')
      end
    },
    { '<leader>gd', "<cmd>Gitsigns toggle_deleted<cr>" },
    { 'ih',         ':<C-U>Gitsigns select_hunk<CR>',  mode = { 'o', 'x' } },

    { ']c', function()
      if vim.wo.diff then
        vim.cmd.normal({ ']c', bang = true })
      else
        require('gitsigns').nav_hunk('next')
      end
    end
    },
    { '[c', function()
      if vim.wo.diff then
        vim.cmd.normal({ '[c', bang = true })
      else
        require('gitsigns').nav_hunk('prev')
      end
    end
    },
  },
}

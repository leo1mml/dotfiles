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
    { '<leader>gs', "<cmd>Gitsigns stage_hunk<cr>", { desc = "Stage Hunk" } },
    { '<leader>gr', "<cmd>Gitsigns reset_hunk<cr>", { desc = "Reset Hunk" } },
    {
      '<leader>gs',
      function()
        require('gitsigns').stage_hunk { vim.fn.line('.'), vim.fn.line('v') }
      end,
      mode = 'v',
      { desc = "Stage Selected" }
    },
    {
      '<leader>gr',
      function()
        require('gitsigns').reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
      end,
      mode = 'v',
      { desc = "Reset Selected" }
    },
    { '<leader>gS', "<cmd>Gitsigns stage_buffer<cr>",    { desc = "Stage Buffer" } },
    { '<leader>gu', "<cmd>Gitsigns undo_stage_hunk<cr>", { desc = "Undo Stage" } },
    { '<leader>gR', "<cmd>Gitsigns reset_buffer<cr>",    { desc = "Reset Buffer" } },
    { '<leader>gp', "<cmd>Gitsigns preview_hunk<cr>",    { desc = "Preview Hunk" } },
    { '<leader>gb',
      function()
        require('gitsigns').blame_line { full = true }
      end
    },
    { '<leader>gb', "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle line blame" } },
    { '<leader>gd', "<cmd>Gitsigns diffthis<cr>",                  { desc = "Diff this" } },
    { '<leader>gD',
      function()
        require('gitsigns').diffthis('~')
      end,
      { desc = "Diff file" }
    },
    { '<leader>gd', "<cmd>Gitsigns toggle_deleted<cr>", { desc = "Toggle Deleted" } },
    { 'ih',         ':<C-U>Gitsigns select_hunk<CR>',   mode = { 'o', 'x' },        { desc = "Select Hunk" } },

    { ']c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ ']c', bang = true })
        else
          require('gitsigns').nav_hunk('next')
        end
      end,
      { desc = "Next Hunk" }
    },
    { '[c',
      function()
        if vim.wo.diff then
          vim.cmd.normal({ '[c', bang = true })
        else
          require('gitsigns').nav_hunk('prev')
        end
      end,
      { desc = "Previous Hunk" }
    },
  },
}

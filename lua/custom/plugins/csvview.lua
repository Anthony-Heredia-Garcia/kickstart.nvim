return {
  -- CSV file viewer
  {
    'hat0uma/csvview.nvim',
    config = function()
      require('csvview').setup { view = { display_mode = 'border' } }
    end,
  },
  vim.keymap.set('n', '<leader>csv', '<CMD>CsvViewToggle<CR>', { desc = 'Toggle CSV Viewer' }),
}

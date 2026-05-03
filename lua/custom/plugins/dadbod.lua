return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod' },
    {
      'kristijanhusak/vim-dadbod-completion',
      ft = { 'sql', 'mysql', 'plsql' },
      config = function()
        vim.api.nvim_create_autocmd('FileType', {
          pattern = { 'sql', 'mysql', 'plsql' },
          callback = function()
            require('cmp').setup.buffer {
              sources = {
                { name = 'vim-dadbod-completion' },
                { name = 'buffer' },
              },
            }
          end,
        })
      end,
    },
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    vim.g.db_ui_use_nerd_fonts = 1
  end,
}

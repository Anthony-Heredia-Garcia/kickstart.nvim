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

    local function urlencode(s)
      return (tostring(s or '')):gsub('[^%w%-%.%_%~]', function(c)
        return string.format('%%%02X', string.byte(c))
      end)
    end

    local username = vim.env.DB_PROD_USERNAME or ''
    local password = vim.env.DB_PROD_PASSWORD or ''
    local host = vim.env.DB_PROD_HOST or ''
    local database = vim.env.DB_PROD_DATABASE or ''

    vim.g.dbs = {
      {
        name = 'prod-read-only',
        url = ('mysql://%s:%s@%s/%s'):format(urlencode(username), urlencode(password), host, database),
      },
    }
  end,
}

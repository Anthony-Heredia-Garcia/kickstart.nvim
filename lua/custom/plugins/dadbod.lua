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

    -- Fetched from 1Password on first use (opening DBUI), then cached for this session.
    local prod_url
    local function resolve_prod_url()
      if prod_url then
        return prod_url
      end

      -- stylua: ignore
      local result = vim
        .system({
          'op', 'item', 'get', 'PROD-READ-ONLY',
          '--vault', 'Private',
          '--fields', 'label=server,label=database,label=username,label=password',
          '--reveal',
          '--format', 'json',
        }, { text = true })
        :wait()
      if result.code ~= 0 then
        error('1Password lookup failed: ' .. vim.trim(result.stderr or ''))
      end

      local fields = {}
      for _, field in ipairs(vim.json.decode(result.stdout)) do
        fields[field.label] = field.value
      end

      -- dadbod passes query params to the mysql client as --flags; give up if unreachable (e.g. off home wifi)
      prod_url = ('mysql://%s:%s@%s/%s?connect_timeout=3'):format(
        urlencode(fields.username),
        urlencode(fields.password),
        fields.server or '',
        fields.database or ''
      )
      return prod_url
    end

    vim.g.dbs = {
      {
        name = 'prod-read-only',
        url = resolve_prod_url,
      },
    }
  end,
}

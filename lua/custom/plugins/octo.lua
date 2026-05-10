return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  config = true,
  keys = {
    { '<leader>go', '<cmd>Octo<cr>', desc = 'Octo' },
    { '<leader>gpr', '<cmd>Octo pr list<cr>', desc = 'List PRs' },
    { '<leader>gpc', '<cmd>Octo pr checkout<cr>', desc = 'Checkout PR' },
    { '<leader>gi', '<cmd>Octo issue list<cr>', desc = 'List issues' },
    { '<leader>gr', '<cmd>Octo review start<cr>', desc = 'Start review' },
  },
}

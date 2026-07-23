return {
  -- Highlight color codes (hex, rgb, hsl, named colors) with their actual color
  {
    'catgoose/nvim-colorizer.lua',
    event = 'BufReadPre',
    opts = {
      user_default_options = {
        mode = 'background',
      },
    },
  },
}

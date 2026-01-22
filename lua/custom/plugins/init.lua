-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  -- Scroll bar on the right, to show you how monumentous your code is
  {
    'petertriho/nvim-scrollbar',
    config = function()
      require('scrollbar').setup {
        show = true,
        handle = {
          color = '#5c6370',
        },
        marks = {
          Search = { color = 'orange' },
          Error = { color = 'red' },
          Warn = { color = 'yellow' },
          Info = { color = 'blue' },
          Hint = { color = 'green' },
        },
      }
      require('scrollbar.handlers.gitsigns').setup()
    end,
  },

  -- Sticky scroll like VSCode
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesitter-context').setup {
        enable = true,
        max_lines = 5, -- how many lines can stick
        trim_scope = 'outer', -- keep outer scope visible
        mode = 'cursor', -- or "topline"
        separator = '_', -- set to "-" if you want a divider
      }
    end,
  },
}

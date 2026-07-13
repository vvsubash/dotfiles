-- plugins/dadbod.lua: Database client and UI

return {
  'tpope/vim-dadbod',
  dependencies = {
    'kristijanhusak/vim-dadbod-ui',
    'kristijanhusak/vim-dadbod-completion',
  },
  cmd = {
    'DB',
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Configure vim-dadbod-ui to use nerd fonts
    vim.g.db_ui_use_nerd_fonts = 1
  end,
  config = function()
    -- Set up omnifunc for dadbod completion in SQL files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'sql', 'mysql', 'plsql' },
      callback = function()
        vim.opt_local.omnifunc = 'vim_dadbod_completion#omni'
      end,
      desc = 'Enable vim-dadbod-completion omnifunc for SQL files',
    })

    -- Make dadbod query results appear in a floating window like Telescope
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'dbout',
      callback = function(args)
        -- Use vim.schedule to ensure the window has been fully created before modifying it
        vim.schedule(function()
          local win = vim.fn.bufwinid(args.buf)
          if win == -1 then return end
          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.8)

          vim.api.nvim_win_set_config(win, {
            relative = 'editor',
            width = width,
            height = height,
            row = math.floor((vim.o.lines - height) / 2),
            col = math.floor((vim.o.columns - width) / 2),
            style = 'minimal',
            border = 'rounded',
            zindex = 50,
          })
          
          -- Focus the floating window
          vim.api.nvim_set_current_win(win)

          -- Map 'q' to quickly close the floating results window
          vim.keymap.set('n', 'q', '<cmd>q<cr>', { buffer = args.buf, silent = true, desc = 'Close dadbod results' })
        end)
      end,
      desc = 'Open dadbod query results in a floating window',
    })
  end,
  keys = {
    { '<leader>db', '<cmd>DBUIToggle<cr>', desc = 'Toggle DB UI' },
    { '<leader>S', '<cmd>DBUIToggle<cr>', desc = 'Toggle DB UI' },
  },
}

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dbui",
  callback = function()
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_config(win, {
      relative = "editor",
      width = math.floor(vim.o.columns * 0.8),
      height = math.floor(vim.o.lines * 0.8),
      row = math.floor(vim.o.lines * 0.1),
      col = math.floor(vim.o.columns * 0.1),
      style = "minimal",
      border = "rounded"
    })
  end
})

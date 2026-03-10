-- plugins/rose-pine.lua: Rose Pine color scheme

return {
  "rose-pine/neovim",
  name = "rose-pine",
  priority = 1000,
  config = function()
    require("rose-pine").setup({ variant = "main" })
    vim.cmd.colorscheme("rose-pine")
  end,
}

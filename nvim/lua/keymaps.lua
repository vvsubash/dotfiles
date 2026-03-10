-- keymaps.lua: Arrow key training and general keymaps

-- Disable arrow keys in normal, insert, and visual modes
vim.keymap.set({ "n", "i", "v" }, "<Up>", function()
  vim.api.nvim_echo({ { "Use k", "WarningMsg" } }, false, {})
end)
vim.keymap.set({ "n", "i", "v" }, "<Down>", function()
  vim.api.nvim_echo({ { "Use j", "WarningMsg" } }, false, {})
end)
vim.keymap.set({ "n", "i", "v" }, "<Left>", function()
  vim.api.nvim_echo({ { "Use h", "WarningMsg" } }, false, {})
end)
vim.keymap.set({ "n", "i", "v" }, "<Right>", function()
  vim.api.nvim_echo({ { "Use l", "WarningMsg" } }, false, {})
end)

-- Use kk to exit insert mode instead of Esc
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("i", "<Esc>", function()
  vim.api.nvim_echo({ { "Use kk", "WarningMsg" } }, false, {})
end)

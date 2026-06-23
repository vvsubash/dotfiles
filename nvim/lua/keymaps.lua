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
vim.keymap.set("i", "jj","<Esc>")
vim.keymap.set("i", "kk", "<Esc>")


-- Use CTRL+<h,j,k,l> in insert mode to move in insert mode
vim.keymap.set("i", "<C-h>", "<C-o>h", { desc = "Move left in insert mode" })
vim.keymap.set("i", "<C-j>", "<C-o>j", { desc = "Move down in insert mode" })
vim.keymap.set("i", "<C-k>", "<C-o>k", { desc = "Move up in insert mode" })
vim.keymap.set("i", "<C-l>", "<C-o>l", { desc = "Move right in insert mode" })

-- Save file keymaps
vim.keymap.set("n", "<leader>s", "<cmd>write<CR>", { desc = "Save open file" })
vim.keymap.set("n", "<leader>ss", "<cmd>wall<CR>", { desc = "Save all files" })

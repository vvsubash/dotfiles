-- keymaps.lua: Arrow key training and general keymaps

-- Disable arrow keys in normal, insert, and visual modes
for arrow, key in pairs({ Up = "k", Down = "j", Left = "h", Right = "l" }) do
  vim.keymap.set({ "n", "i", "v" }, "<" .. arrow .. ">", function()
    vim.api.nvim_echo({ { "Use " .. key, "WarningMsg" } }, false, {})
  end)
end

-- Use kk to exit insert mode instead of Esc
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("i", "<Esc>", function()
  vim.api.nvim_echo({ { "Use kk", "WarningMsg" } }, false, {})
end)

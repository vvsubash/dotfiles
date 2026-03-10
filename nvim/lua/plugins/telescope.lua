-- plugins/telescope.lua: Fuzzy finder

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local ok, builtin = pcall(require, "telescope.builtin")
    if ok and builtin then
      vim.keymap.set("n", "<leader>f", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
    end
  end,
}

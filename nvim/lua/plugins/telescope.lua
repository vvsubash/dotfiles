-- plugins/telescope.lua: Fuzzy finder

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("telescope").setup({
      defaults = {
        mappings = {
          i = {
            ["kk"] = require("telescope.actions").close,
          },
        },
      },
    })

    local builtin = require("telescope.builtin")
    -- Find files (hidden included, .git excluded)
    vim.keymap.set("n", "<leader>ff", function()
      builtin.find_files({ hidden = true })
    end, { desc = "Find files" })
    -- Live grep (hidden included)
    vim.keymap.set("n", "<leader>fg", function()
      builtin.live_grep({ additional_args = { "--hidden" } })
    end, { desc = "Live grep" })
  end,
}

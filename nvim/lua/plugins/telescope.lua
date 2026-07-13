-- plugins/telescope.lua: Fuzzy finder

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local telescope_ok, telescope = pcall(require, "telescope")
    if not telescope_ok then return end

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["kk"] = require("telescope.actions").close,
          },
        },
      },
    })

    local ok, builtin = pcall(require, "telescope.builtin")
    if ok and builtin then
      -- Find files (including hidden files like .app, but excluding .git)
      vim.keymap.set("n", "<leader>ff", function()
        builtin.find_files({ 
          previewer = true,
          hidden = true,
          -- Optional: If .app is in your .gitignore, uncomment the line below to search ignored files too
          -- no_ignore = true,
        })
      end, { desc = "Find files" })
      
      -- Live grep (including hidden files like .app)
      vim.keymap.set("n", "<leader>fg", function()
        builtin.live_grep({ 
          previewer = true,
          additional_args = function()
            return { "--hidden" }
            -- return { "--hidden", "--no-ignore" } -- Uncomment to also search ignored files
          end
        })
      end, { desc = "Live grep" })
    end
  end,
}

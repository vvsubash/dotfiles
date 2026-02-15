vim.cmd("set relativenumber")

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

vim.keymap.set({"n", "i","v"}, "<Up>", function()
  vim.api.nvim_echo({{"Use k", "WarningMsg"}}, false, {})
end)
vim.keymap.set({"n","i", "v"}, "<Down>", function()
  vim.api.nvim_echo({{'Use j', "WarningMsg"}}, false, {})
end)
vim.keymap.set({"n","i", "v"}, "<Left>", function()
  vim.api.nvim_echo({{'Use h', "WarningMsg"}}, false, {})
end)
vim.keymap.set({"n","i", "v"}, "<Right>", function()
  vim.api.nvim_echo({{'Use l', "WarningMsg"}}, false, {})
end)
vim.keymap.set("i", "kk", "<Esc>")
vim.keymap.set("i", "<Esc>", function()
  vim.api.nvim_echo({{"Use kk", "WarningMsg"}}, false, {})
end)
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
  spec = {
    { "rose-pine/neovim", name = "rose-pine" },

    {
      "nvim-telescope/telescope.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },

    {
      "nvim-treesitter/nvim-treesitter",
      branch = "master",
      lazy = false,
      build = ":TSUpdate",
      config = function()
        require("nvim-treesitter.configs").setup({
          ensure_installed = { "lua", "javascript", "typescript", "vue", "go", "gomod", "gosum", "css" },
          highlight = { enable = true },
          indent = { enable = true },
        })
      end,
    },

    -- Neo-tree with sensible defaults
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", 
        "MunifTanjim/nui.nvim",
      },
      keys = {
        { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Neo-tree: toggle" },
        { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Neo-tree: reveal current file" },
      },
      config = function()
        require("neo-tree").setup({
          close_if_last_window = true,
          popup_border_style = "rounded",
          enable_git_status = true,
          enable_diagnostics = false,
          default_source = "filesystem",
          sources = { "filesystem", "buffers", "git_status" },
          window = {
            position = "left",
            width = 32,
            mappings = {
              ["<cr>"] = "open",
              ["o"] = "open",
              ["s"] = "open_split",
              ["v"] = "open_vsplit",
              ["t"] = "open_tabnew",
              ["q"] = "close_window",
              ["R"] = "refresh",
            },
          },
          filesystem = {
            bind_to_cwd = true,
            cwd_target = {
              sidebar = "global",
              current = "global",
            },
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            filtered_items = {
              visible = false,         -- set true to show filtered by default
              hide_dotfiles = true,
              hide_gitignored = true,
              hide_by_name = { "node_modules", ".git" },
            },
          },
          buffers = {
            follow_current_file = true,
            group_empty_dirs = true,
          },
          git_status = {
            window = { position = "float" },
          },
        })
      end,
    },
  },

  checker = { enabled = true },
})

require("rose-pine").setup({ variant = "main" })
vim.cmd.colorscheme("rose-pine")

local ok, builtin = pcall(require, "telescope.builtin")
if ok and builtin then
  vim.keymap.set("n", "<leader>f", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
end

-- init.lua: Entry point for Neovim configuration
--
-- Module layout:
--   lua/options.lua          General settings (line numbers, indentation, leader)
--   lua/keymaps.lua          Arrow key training and insert-mode remaps
--   lua/lazy_bootstrap.lua   lazy.nvim bootstrap and plugin loader
--   lua/plugins/             One file per plugin (auto-imported by lazy.nvim)
--     rose-pine.lua          Color scheme
--     telescope.lua          Fuzzy finder
--     treesitter.lua         Syntax highlighting
--     neo-tree.lua           File explorer

require("options")
require("keymaps")
require("lazy_bootstrap")

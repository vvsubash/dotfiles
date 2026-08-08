-- plugins/neo-tree.lua: File explorer sidebar

return {
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
    { "<leader>o", "<cmd>Neotree focus<cr>", desc = "Neo-tree: focus" },
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
          visible = false,
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
}

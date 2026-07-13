-- plugins/treesitter.lua: Syntax highlighting and indentation

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "master",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "javascript", "typescript", "vue", "go", "gomod", "gosum", "css", "sql", "terraform", "hcl" },
      highlight = { enable = true },
      indent = { enable = true },
    })
  end,
}

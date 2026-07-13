-- plugins/conform.lua: Formatting via conform.nvim

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      vue = { "prettierd" },
      javascript = { "oxfmt" },
      typescript = { "oxfmt" },
    },
    format_on_save = {
      timeout_ms = 500,
    },
    formatters = {
      oxfmt = {
        command = "oxfmt",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
      },
    },
  },
}

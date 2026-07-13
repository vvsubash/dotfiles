-- plugins/lint.lua: Linting via nvim-lint

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      vue = { "oxlint" },
      javascript = { "oxlint" },
      typescript = { "oxlint" },
    }

    lint.linters.oxlint = {
      cmd = "oxlint",
      args = { "--format", "unix", "$FILENAME" },
      stdin = false,
      stream = "stdout",
      ignore_exitcode = true,
      parser = require("lint.parser").from_pattern(
        "^(.+):(%d+):(%d+): (.+) %[(%a+)%]",
        { "file", "lnum", "col", "message", "severity" },
        {
          error = vim.diagnostic.severity.ERROR,
          warning = vim.diagnostic.severity.WARN,
        },
        { source = "oxlint" }
      ),
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        lint.try_lint()
      end,
    })
  end,
}

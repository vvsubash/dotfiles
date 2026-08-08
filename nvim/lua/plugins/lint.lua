-- plugins/lint.lua: Linting via nvim-lint
-- JS/TS linter is chosen per project: eslint if the project configures it,
-- otherwise oxlint (zero-config, fast).

local eslint_cfg = {
  ".eslintrc",
  ".eslintrc.js",
  ".eslintrc.cjs",
  ".eslintrc.mjs",
  ".eslintrc.json",
  ".eslintrc.yml",
  ".eslintrc.yaml",
  "eslint.config.js",
  "eslint.config.cjs",
  "eslint.config.mjs",
  "eslint.config.ts",
}

local lint_fts = {
  vue = true,
  javascript = true,
  javascriptreact = true,
  typescript = true,
  typescriptreact = true,
}

local function find_up(names)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
  return vim.fs.find(names, { upward = true, path = dir })[1]
end

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
      callback = function()
        if not lint_fts[vim.bo.filetype] then
          return
        end
        -- oxlint can't read the .tsrx extension, so lint those with eslint.
        if vim.fn.expand("%:e") == "tsrx" then
          lint.try_lint("eslint")
        elseif find_up(eslint_cfg) then
          lint.try_lint("eslint")
        else
          lint.try_lint("oxlint")
        end
      end,
    })
  end,
}

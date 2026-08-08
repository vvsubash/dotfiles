-- plugins/conform.lua: Formatting via conform.nvim
-- JS/TS formatter is chosen per project: prettier if the project configures it,
-- otherwise oxfmt.

local prettier_cfg = {
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.ts",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
  "prettier.config.ts",
}

local function find_up(names, bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr or 0))
  return vim.fs.find(names, { upward = true, path = dir })[1]
end

-- Prettier is also commonly configured via a "prettier" key in package.json.
local function pkg_has_prettier(bufnr)
  local pkg = find_up({ "package.json" }, bufnr)
  if not pkg then
    return false
  end
  local ok, lines = pcall(vim.fn.readfile, pkg)
  return ok and table.concat(lines, "\n"):find('"prettier"%s*:') ~= nil
end

local function js_formatter(bufnr)
  if find_up(prettier_cfg, bufnr) or pkg_has_prettier(bufnr) then
    return { "prettier" }
  end
  return { "oxfmt" }
end

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
      vue = { "prettier" },
      javascript = js_formatter,
      javascriptreact = js_formatter,
      typescript = js_formatter,
      typescriptreact = js_formatter, -- also covers .tsrx (mapped to typescriptreact)
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback", -- filetypes without a formatter use their LSP
    },
    formatters = {
      oxfmt = {
        command = "oxfmt",
        -- oxfmt picks the parser from the extension; .tsrx is unknown, so present it as .tsx.
        args = function(_, ctx)
          return { "--stdin-filepath", (ctx.filename:gsub("%.tsrx$", ".tsx")) }
        end,
        stdin = true,
      },
      -- ponytail: .tsrx + prettier not handled (prettier can't parse .tsrx); add a
      -- filename-rewrite override like oxfmt above if a prettier project uses .tsrx.
    },
  },
}

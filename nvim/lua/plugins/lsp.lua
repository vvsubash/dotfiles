-- plugins/lsp.lua: Language Server Protocol configuration

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    require("mason").setup()

    local mason_lspconfig = require("mason-lspconfig")
    mason_lspconfig.setup({
      ensure_installed = { "sqls", "ts_ls" }, -- Install SQL and TypeScript language servers
    })

    -- Dynamically locate the global TypeScript library path (for TypeScript 7 RC)
    local global_ts_lib = nil
    local npm_root_ok, npm_root_output = pcall(vim.fn.system, "npm root -g")
    if npm_root_ok then
      local lines = vim.split(vim.fn.trim(npm_root_output), "\n")
      local npm_root = lines[#lines]
      if npm_root and npm_root ~= "" then
        local path = npm_root .. "/typescript/lib"
        if vim.fn.isdirectory(path) == 1 then
          global_ts_lib = path
        end
      end
    end

    if global_ts_lib and vim.lsp.config then
      vim.lsp.config("ts_ls", {
        init_options = {
          tsdk = global_ts_lib,
        },
      })
    end

    -- Configure diagnostic options (show errors inline as virtual text)
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
      },
    })

    -- Basic LSP keymaps
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = ev.buf, desc = "Go to definition" })
        vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "Hover documentation" })
        vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename symbol" })
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "Code action" })
      end,
    })
  end,
}

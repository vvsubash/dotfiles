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
      ensure_installed = { "sqls", "terraformls", "tflint", "vue_ls", "ts_ls", "tailwindcss" },
    })

    -- Globally override hover and signature_help to use rounded borders (Neovim 0.11+ compatible)
    vim.lsp.buf.hover = (function(original_hover)
      return function(opts)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return original_hover(opts)
      end
    end)(vim.lsp.buf.hover)

    vim.lsp.buf.signature_help = (function(original_sig_help)
      return function(opts)
        opts = opts or {}
        opts.border = opts.border or "rounded"
        return original_sig_help(opts)
      end
    end)(vim.lsp.buf.signature_help)

    -- Configure diagnostic display options explicitly
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
        source = "if_many",
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN]  = "▲",
          [vim.diagnostic.severity.HINT]  = "⚑",
          [vim.diagnostic.severity.INFO]  = "»",
        },
      },
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

    -- Configure TypeScript server for Vue Hybrid Mode using Neovim 0.11+ native config API
    local vue_ts_plugin_location = vim.fn.stdpath("data")
      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"

    vim.lsp.config("ts_ls", {
      init_options = {
        tsdk = global_ts_lib,
        plugins = {
          {
            name = "@vue/typescript-plugin",
            location = vue_ts_plugin_location,
            languages = { "javascript", "typescript", "vue" },
          },
        },
      },
      filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
    })

    -- Enable all mason-installed servers (Neovim 0.11+ API)
    local installed = mason_lspconfig.get_installed_servers()
    vim.lsp.enable(installed)

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

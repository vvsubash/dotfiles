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
      ensure_installed = { "sqls", "terraformls", "tflint", "vue_ls", "tailwindcss" },
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

    -- TypeScript 7 native LSP: the global `tsc` (typescript@7) binary speaks LSP directly
    if vim.fn.executable("tsc") == 1 then
      vim.lsp.config("ts7", {
        cmd = { "tsc", "--lsp", "-stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
        root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
      })
      vim.lsp.enable("ts7")
    end

    -- Enable all mason-installed servers (Neovim 0.11+ API);
    -- skip ts_ls if still installed — TS7 native LSP replaces it
    local installed = vim.tbl_filter(function(s)
      return s ~= "ts_ls"
    end, mason_lspconfig.get_installed_servers())
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

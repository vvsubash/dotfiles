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
      -- Drive vim.lsp.enable ourselves; otherwise mason-lspconfig auto-enables
      -- every installed server (e.g. ts_ls alongside tsgo → duplicate TS clients).
      automatic_enable = false,
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

    -- TypeScript / Vue LSP routing (decided once per session from the cwd project).
    --
    -- Vue Language Tools v3 (vue_ls, hybrid mode) needs a *conventional* TS client
    -- running @vue/typescript-plugin. The TS7 native server (tsgo) cannot be that
    -- client yet: it doesn't expose the TS language-service plugin API Vue relies
    -- on (open since 2025: https://github.com/vuejs/language-tools/issues/5381).
    -- So Vue projects use ts_ls + vue_ls; every other project uses tsgo (TS7
    -- native) when a tsgo binary is available, else falls back to ts_ls.
    --
    -- Limitation: routing keys off getcwd(), not per-buffer roots, so open one
    -- project per session. A monorepo mixing Vue and non-Vue packages would need
    -- per-root detection instead.
    local function is_vue_project()
      local cwd = vim.fn.getcwd()
      local ok, lines = pcall(vim.fn.readfile, cwd .. "/package.json")
      if ok and #lines > 0 then
        local decoded = vim.json.decode(table.concat(lines, "\n")) or {}
        local deps = vim.tbl_extend("force", decoded.dependencies or {}, decoded.devDependencies or {})
        if deps["vue"] or deps["nuxt"] or deps["@vue/compiler-sfc"] then
          return true
        end
      end
      return vim.fn.glob(cwd .. "/vue.config.*") ~= ""
    end

    local function has_tsgo()
      return vim.fn.executable("tsgo") == 1
        or vim.fn.executable(vim.fn.getcwd() .. "/node_modules/.bin/tsgo") == 1
    end

    if is_vue_project() then
      -- Hybrid mode: ts_ls carries @vue/typescript-plugin and also serves the
      -- project's .ts/.tsx so cross-file navigation/rename with .vue works;
      -- vue_ls handles the SFC template/style. (vtsls is a drop-in swap here.)
      local vue_plugin = {
        name = "@vue/typescript-plugin",
        location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
        languages = { "vue" },
        configNamespace = "typescript",
      }
      vim.lsp.config("ts_ls", {
        init_options = { plugins = { vue_plugin } },
        filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
      })
      vim.lsp.enable({ "ts_ls", "vue_ls" })
    elseif has_tsgo() then
      vim.lsp.enable("tsgo") -- lspconfig built-in def; prefers node_modules/.bin/tsgo, else global
    else
      vim.lsp.enable("ts_ls") -- TS7 native not installed; use classic tsserver
    end

    -- Enable the remaining mason-installed servers. ts_ls and vue_ls are driven
    -- explicitly above, so exclude them here — otherwise vue_ls would attach with
    -- no TS companion (the "Could not find ts_ls/vtsls" error).
    local explicit = { ts_ls = true, vue_ls = true }
    local installed = vim.tbl_filter(function(s)
      return not explicit[s]
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

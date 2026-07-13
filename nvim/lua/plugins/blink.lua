-- plugins/blink.lua: Fast, Rust-based completion engine

return {
  'saghen/blink.cmp',
  version = '*', -- Download pre-built binaries
  dependencies = { 'rafamadriz/friendly-snippets' },
  opts = {
    keymap = { preset = 'default' },
    appearance = {
      use_neovim_glow = true,
      nerd_font_variant = 'mono',
    },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
      per_filetype = {
        sql = { 'snippets', 'dadbod', 'buffer' },
        mysql = { 'snippets', 'dadbod', 'buffer' },
        plsql = { 'snippets', 'dadbod', 'buffer' },
      },
      providers = {
        dadbod = {
          name = 'Dadbod',
          module = 'vim_dadbod_completion.blink',
        },
      },
    },
  },
}

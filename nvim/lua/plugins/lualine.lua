-- plugins/lualine.lua: Styled statusline matching the Rose Pine theme

return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local ok, lualine = pcall(require, 'lualine')
    if not ok then return end

    lualine.setup({
      options = {
        theme = 'rose-pine',
        component_separators = { left = '│', right = '│' },
        section_separators = { left = '', right = '' },
        globalstatus = true,
      },
    })
  end,
}

# Neovim Configuration

## Overview

The Neovim configuration lives in the `nvim/` directory using a modular layout. The entire directory is symlinked to `~/.config/nvim/` by the install script. Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim).

## File Structure

```
nvim/
  init.lua                  Entry point -- loads the three modules below
  lua/
    options.lua             General settings (line numbers, indentation, leader)
    keymaps.lua             Arrow key training and insert-mode remaps
    lazy_bootstrap.lua      lazy.nvim bootstrap and plugin loader
    plugins/                One file per plugin (auto-imported by lazy.nvim)
      rose-pine.lua         Color scheme
      telescope.lua         Fuzzy finder
      treesitter.lua        Syntax highlighting
      neo-tree.lua          File explorer
      opencode.lua          AI assistant integration
```

### How it loads

1. `init.lua` calls `require("options")`, `require("keymaps")`, `require("lazy_bootstrap")`
2. `lazy_bootstrap.lua` bootstraps lazy.nvim and calls `{ import = "plugins" }`
3. lazy.nvim auto-discovers every `lua/plugins/*.lua` file and loads each plugin spec

To add a new plugin, create a new file in `lua/plugins/` that returns a lazy.nvim spec table.

## General Settings

_File: `lua/options.lua`_

| Setting          | Value    |
|------------------|----------|
| Line numbers     | Relative |
| Indentation      | 2 spaces |
| Tab behavior     | Expand tabs to spaces |
| Leader key       | `Space`  |
| Local leader key | `\`      |

## Arrow Key Training

_File: `lua/keymaps.lua`_

Arrow keys are disabled in normal, insert, and visual modes. Instead of performing their usual action, they display a warning message reminding you to use Vim motions:

| Disabled Key | Message   |
|-------------|-----------|
| `Up`        | "Use k"   |
| `Down`      | "Use j"   |
| `Left`      | "Use h"   |
| `Right`     | "Use l"   |

Additionally, `Esc` is disabled in insert mode with a reminder to use `kk` instead.

## Plugins

Each plugin lives in its own file under `lua/plugins/`.

### Rose Pine (Theme)

_File: `lua/plugins/rose-pine.lua`_

- **Plugin**: `rose-pine/neovim`
- **Variant**: `main` (dark theme)
- Applied globally as the colorscheme with highest priority.

### Telescope (Fuzzy Finder)

_File: `lua/plugins/telescope.lua`_

- **Plugin**: `nvim-telescope/telescope.nvim`
- **Dependency**: `nvim-lua/plenary.nvim`

| Keymap       | Action       |
|-------------|--------------|
| `<leader>f`  | Find files   |
| `<leader>fg` | Live grep    |

### Treesitter (Syntax Highlighting)

_File: `lua/plugins/treesitter.lua`_

- **Plugin**: `nvim-treesitter/nvim-treesitter`
- **Features**: Highlighting and indentation enabled.
- **Installed parsers**: `lua`, `javascript`, `typescript`, `vue`, `go`, `gomod`, `gosum`, `css`

### Neo-tree (File Explorer)

_File: `lua/plugins/neo-tree.lua`_

- **Plugin**: `nvim-neo-tree/neo-tree.nvim` (v3.x)
- **Dependencies**: `plenary.nvim`, `nvim-web-devicons`, `nui.nvim`
- **Position**: Left sidebar, 32 columns wide

| Keymap       | Action                   |
|-------------|--------------------------|
| `<leader>e`  | Toggle Neo-tree          |
| `<leader>E`  | Reveal current file      |

**Neo-tree window keymaps:**

| Key     | Action         |
|---------|---------------|
| `Enter` | Open file      |
| `o`     | Open file      |
| `s`     | Open in split  |
| `v`     | Open in vsplit |
| `t`     | Open in new tab|
| `q`     | Close window   |
| `R`     | Refresh        |

**Filesystem settings:**
- Follows the current file automatically
- Uses libuv file watcher for live updates
- Hides dotfiles, gitignored files, `node_modules/`, and `.git/` by default

### opencode.nvim (AI Assistant)

_File: `lua/plugins/opencode.lua`_

- **Plugin**: `nickjvandyke/opencode.nvim`
- **Version**: Latest stable (`*`)
- **Optional dependency**: `folke/snacks.nvim` (enhances input/picker UX)
- **Prerequisite**: [opencode CLI](https://github.com/sst/opencode) must be installed
- Sets `autoread = true` for automatic file reload on edits.

| Keymap      | Mode  | Action                        |
|------------|-------|-------------------------------|
| `Ctrl+a`    | n, x  | Ask opencode with `@this` context |
| `Ctrl+x`    | n, x  | Select an opencode action     |
| `Ctrl+.`    | n, t  | Toggle opencode panel         |
| `go`        | n, x  | Operator: add range to opencode |
| `goo`       | n     | Add current line to opencode  |
| `Shift+Ctrl+u` | n | Scroll opencode up            |
| `Shift+Ctrl+d` | n | Scroll opencode down          |
| `+`         | n     | Increment number (remapped)   |
| `-`         | n     | Decrement number (remapped)   |

Run `:checkhealth opencode` after setup to verify.

## Plugin Management

_File: `lua/lazy_bootstrap.lua`_

lazy.nvim auto-bootstraps on first launch. The lock file at `~/.config/nvim/lazy-lock.json` pins plugin versions.

| Command              | Action                  |
|---------------------|-------------------------|
| `:Lazy`              | Open lazy.nvim dashboard |
| `:Lazy sync`         | Install/update plugins   |
| `:Lazy clean`        | Remove unused plugins    |
| `:Lazy health`       | Check plugin health      |

## Adding a New Plugin

1. Create a new file in `nvim/lua/plugins/` (e.g., `my-plugin.lua`)
2. Return a lazy.nvim spec table from the file:
   ```lua
   return {
     "owner/repo",
     config = function()
       require("my-plugin").setup({})
     end,
   }
   ```
3. Restart Neovim or run `:Lazy sync`

## Printing This Documentation

```bash
# Print to terminal
cat ~/dev/dotfiles/docs/nvim.md

# Render as formatted markdown (requires glow)
glow ~/dev/dotfiles/docs/nvim.md

# Print to paper / PDF (requires pandoc)
pandoc ~/dev/dotfiles/docs/nvim.md -o nvim-config.pdf
```

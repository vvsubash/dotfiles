# Dotfiles

Personal development environment configuration for macOS and WSL2.

## What's Included

| Directory     | Tool       | Description                        |
|--------------|------------|-------------------------------------|
| `alacritty/` | Alacritty  | GPU-accelerated terminal emulator   |
| `git/`       | Git        | Version control configuration       |
| `nvim/`      | Neovim     | Text editor (lazy.nvim + plugins)   |
| `tmux/`      | Tmux       | Terminal multiplexer                |
| `zsh/`       | Zsh        | Shell configuration                 |

## Theme

Everything uses the [Rose Pine](https://rosepinetheme.com/) color scheme (main/dark variant):

- Neovim: `rose-pine/neovim`
- Alacritty: `rose-pine.toml` (with moon and dawn variants available)
- Tmux: `rose-pine/tmux`

## Installation

### macOS

```bash
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

### WSL2 / Linux

```bash
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./install-wsl2-nix.sh
```

See [docs/installation.md](docs/installation.md) for full details on what gets installed and configured.

## Key Decisions

- **Modular Neovim config**: Split into `lua/options.lua`, `lua/keymaps.lua`, `lua/lazy_bootstrap.lua`, and one file per plugin under `lua/plugins/`.
- **Arrow keys disabled**: Enforces Vim motions (`h/j/k/l`). `Esc` is remapped to `kk` in insert mode.
- **Tmux prefix**: `Ctrl+Space` instead of the default `Ctrl+b`.
- **Space as leader**: Neovim leader key is `Space`.
- **Font**: IosevkaTerm Nerd Font (must be installed separately).

## Documentation

Detailed documentation for each component:

- [Alacritty](docs/alacritty.md) -- Window, font, keybindings, and theme configuration
- [Git](docs/git.md) -- Credentials, user identity, and global gitignore
- [Neovim](docs/nvim.md) -- Plugins, keymaps, and settings
- [Tmux](docs/tmux.md) -- Prefix key, pane navigation, and plugins
- [Zsh](docs/zsh.md) -- Shell integrations, toolchains, and aliases
- [Installation](docs/installation.md) -- Install scripts and symlink details

## Structure

```
dotfiles/
  alacritty/
    alacritty.toml          # Main config
    rose-pine.toml          # Dark theme (active)
    rose-pine-moon.toml     # Darker theme variant
    rose-pine-dawn.toml     # Light theme variant
  git/
    .gitconfig              # User config
    ignore                  # Global gitignore
  nvim/
    init.lua                # Entry point (loads modules below)
    lua/
      options.lua           # General settings
      keymaps.lua           # Arrow key training, remaps
      lazy_bootstrap.lua    # lazy.nvim bootstrap + plugin loader
      plugins/
        rose-pine.lua       # Color scheme
        telescope.lua       # Fuzzy finder
        treesitter.lua      # Syntax highlighting
        neo-tree.lua        # File explorer
        opencode.lua        # AI assistant
  tmux/
    .tmux.conf              # Tmux configuration
  zsh/
    .zshrc                  # Interactive shell config
    .zshenv                 # Environment variables
    .zprofile               # Login shell setup
    .profile                # POSIX-compatible profile
  docs/                     # Documentation
  install.sh                # macOS installer
  install-wsl2-nix.sh       # WSL2/Nix installer
```

## Prerequisites

- macOS or WSL2 on Windows
- [IosevkaTerm Nerd Font](https://www.nerdfonts.com/) installed
- [opencode CLI](https://github.com/sst/opencode) for the AI assistant plugin (optional)

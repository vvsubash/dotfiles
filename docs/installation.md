# Installation

## Overview

Two install scripts are provided:

| Script               | Platform         | Package Manager |
|---------------------|------------------|-----------------|
| `install.sh`         | macOS            | Homebrew        |
| `install-wsl2-nix.sh`| WSL2 (Linux)    | Nix + apt       |

Both scripts perform the same core tasks: install packages, create symlinks, and set up TPM.

## Quick Start

### macOS

```bash
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
chmod +x install.sh
./install.sh
```

### WSL2 / Linux

```bash
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
chmod +x install-wsl2-nix.sh
./install-wsl2-nix.sh
```

## What the Scripts Do

### 1. Package Manager Setup

**macOS (`install.sh`):** Installs Homebrew if not present, then uses `brew install`.

**WSL2 (`install-wsl2-nix.sh`):** Installs the Nix package manager if not present, also uses `apt` for system dependencies (`build-essential`, `curl`, `wget`, `git`, `libssl-dev`, `pkg-config`).

### 2. Packages Installed

| Package    | Purpose                          |
|-----------|----------------------------------|
| git       | Version control                  |
| neovim    | Text editor                      |
| tmux      | Terminal multiplexer             |
| starship  | Shell prompt                     |
| zoxide    | Smart directory navigation       |
| fnm       | Node.js version manager (macOS only) |
| ripgrep   | Fast text search (`rg`)          |
| fd        | Fast file finder                 |
| fzf       | Fuzzy finder                     |
| jq        | JSON processor                   |
| lazygit   | Git TUI                          |
| tig       | Git text-mode interface          |
| htop      | Process viewer                   |
| wget      | HTTP downloader                  |
| go        | Go programming language          |
| pnpm      | Node.js package manager (macOS)  |
| nodejs    | Node.js runtime (WSL2 via Nix)   |

### 3. TPM (Tmux Plugin Manager)

Clones TPM to `~/.tmux/plugins/tpm` if not already present. Attempts to auto-install tmux plugins after symlinking.

### 4. Symlinks Created

The scripts use a `link()` helper that:
- Removes existing symlinks before re-creating
- Backs up existing files/directories to `*.bak`
- Creates parent directories as needed

| Source                              | Destination                                |
|------------------------------------|--------------------------------------------|
| `zsh/.zshrc`                        | `~/.zshrc`                                 |
| `zsh/.zshenv`                       | `~/.zshenv`                                |
| `zsh/.zprofile`                     | `~/.zprofile`                              |
| `zsh/.profile`                      | `~/.profile`                               |
| `git/.gitconfig`                    | `~/.gitconfig`                             |
| `git/ignore`                        | `~/.config/git/ignore`                     |
| `alacritty/alacritty.toml`          | `~/.config/alacritty/alacritty.toml`       |
| `alacritty/rose-pine.toml`          | `~/.config/alacritty/rose-pine.toml`       |
| `alacritty/rose-pine-moon.toml`     | `~/.config/alacritty/rose-pine-moon.toml`  |
| `alacritty/rose-pine-dawn.toml`     | `~/.config/alacritty/rose-pine-dawn.toml`  |
| `nvim/`                             | `~/.config/nvim`                           |
| `tmux/.tmux.conf`                   | `~/.tmux.conf`                             |

## Post-Install

After running the install script:

1. **Open a new terminal** to load the new shell configuration.
2. **Open Neovim** (`nvim`) -- lazy.nvim will auto-install plugins on first launch.
3. **Open tmux** and press `Ctrl+Space + I` to install tmux plugins (if auto-install failed).
4. **Install the font**: Download and install [IosevkaTerm Nerd Font](https://www.nerdfonts.com/) for Alacritty.

## Backup Behavior

If existing config files are found at symlink destinations, the scripts rename them with a `.bak` extension:

```
[warn] Backing up existing /home/user/.zshrc -> /home/user/.zshrc.bak
```

Existing symlinks are silently replaced.

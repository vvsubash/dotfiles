# Installation

```bash
git clone <repo-url> ~/dev/dotfiles
cd ~/dev/dotfiles
./install.sh
```

`install.sh` installs Homebrew (if missing), the brew packages listed in the
script, TPM, and symlinks each config into place — read the script for the
exact list; it's short. Existing files at symlink destinations are backed up
to `*.bak`; existing symlinks are replaced.

## Post-Install

1. **Open a new terminal** to load the new shell configuration.
2. **Open Neovim** (`nvim`) -- lazy.nvim will auto-install plugins on first launch.
3. **Open tmux** and press `Ctrl+Space + I` to install tmux plugins (if auto-install failed).
4. **Install the font**: Download and install [IosevkaTerm Nerd Font](https://www.nerdfonts.com/) for Alacritty.

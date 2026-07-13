#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

info() { printf "\033[1;34m[info]\033[0m %s\n" "$1"; }
ok()   { printf "\033[1;32m[ok]\033[0m   %s\n" "$1"; }
warn() { printf "\033[1;33m[warn]\033[0m %s\n" "$1"; }

link() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    rm "$dst"
  elif [ -f "$dst" ] || [ -d "$dst" ]; then
    warn "Backing up existing $dst -> ${dst}.bak"
    mv "$dst" "${dst}.bak"
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  ok "Linked $dst -> $src"
}

# ── Homebrew ──────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  ok "Homebrew already installed"
fi

# ── Brew packages ────────────────────────────────────────
info "Installing brew formulae..."
brew install --quiet \
  git \
  neovim \
  tmux \
  starship \
  zoxide \
  fnm \
  ripgrep \
  fd \
  fzf \
  jq \
  lazygit \
  tig \
  htop \
  wget \
  go \
  pnpm \
  2>/dev/null || true

# ── TPM (Tmux Plugin Manager) ───────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  ok "TPM already installed"
fi

# ── Symlinks ─────────────────────────────────────────────
info "Creating symlinks..."

# Zsh
link "$DOTFILES/zsh/.zshrc"     "$HOME/.zshrc"
link "$DOTFILES/zsh/.zshenv"    "$HOME/.zshenv"
link "$DOTFILES/zsh/.zprofile"  "$HOME/.zprofile"
link "$DOTFILES/zsh/.profile"   "$HOME/.profile"

# Git
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
mkdir -p "$HOME/.config/git"
link "$DOTFILES/git/ignore"     "$HOME/.config/git/ignore"

# Alacritty
mkdir -p "$HOME/.config/alacritty"
link "$DOTFILES/alacritty/alacritty.toml"       "$HOME/.config/alacritty/alacritty.toml"
link "$DOTFILES/alacritty/rose-pine.toml"       "$HOME/.config/alacritty/rose-pine.toml"

# Neovim (symlink the entire nvim/ directory)
link "$DOTFILES/nvim"  "$HOME/.config/nvim"

# Tmux
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ── Post-install ─────────────────────────────────────────
info "Installing tmux plugins (press prefix + I in tmux if this fails)..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || warn "Start tmux and press Ctrl+Space + I to install plugins"

echo ""
ok "Dotfiles installed! Open a new terminal to apply changes."

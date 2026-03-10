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

# ── Nix Package Manager ────────────────────────────────────
if ! command -v nix &>/dev/null; then
  info "Installing Nix package manager..."
  curl -L https://nixos.org/nix/install | sh -s -- --daemon
  # Source nix profile for current session
  if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  fi
else
  ok "Nix already installed"
fi

# ── System dependencies (apt) ──────────────────────────────
info "Installing system dependencies via apt..."
sudo apt-get update
sudo apt-get install -y \
  build-essential \
  curl \
  wget \
  git \
  libssl-dev \
  pkg-config \
  2>/dev/null || true

# ── Nix packages ──────────────────────────────────────────
info "Installing packages via Nix..."
nix-env -i \
  git \
  neovim \
  tmux \
  starship \
  zoxide \
  ripgrep \
  fd \
  fzf \
  jq \
  lazygit \
  tig \
  htop \
  wget \
  go \
  nodejs \
  2>/dev/null || true

ok "Nix packages installed"

# ── Node.js setup (latest version) ────────────────────────
info "Setting up Node.js..."
NODE_VERSION=$(node --version)
ok "Node.js $NODE_VERSION installed"

# ── pnpm installation ─────────────────────────────────────
if ! command -v pnpm &>/dev/null; then
  info "Installing pnpm..."
  npm install -g pnpm
  ok "pnpm installed"
else
  ok "pnpm already installed"
fi

# ── TPM (Tmux Plugin Manager) ──────────────────────────────
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  info "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  ok "TPM already installed"
fi

# ── Symlinks ───────────────────────────────────────────────
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
link "$DOTFILES/alacritty/rose-pine-moon.toml"  "$HOME/.config/alacritty/rose-pine-moon.toml"
link "$DOTFILES/alacritty/rose-pine-dawn.toml"  "$HOME/.config/alacritty/rose-pine-dawn.toml"

# Neovim (symlink the entire nvim/ directory)
link "$DOTFILES/nvim"  "$HOME/.config/nvim"

# Tmux
link "$DOTFILES/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ── Post-install ──────────────────────────────────────────
info "Installing tmux plugins (press prefix + I in tmux if this fails)..."
"$HOME/.tmux/plugins/tpm/bin/install_plugins" 2>/dev/null || warn "Start tmux and press Ctrl+Space + I to install plugins"

echo ""
ok "Dotfiles installed for WSL2 with Nix! Open a new terminal to apply changes."

# AGENTS.md - Dotfiles Codebase Rules

This file provides rules and context for AI coding agents operating in this repository.

## Project Overview

This repository contains personal development environment configuration for macOS and WSL2.

- **Languages/Formats:** Shell (bash/zsh), Lua (Neovim), TOML (Alacritty), Tmux conf, Gitconfig.
- **Theme:** Rose Pine (main/dark variant used everywhere).
- **Architecture:** Modular components symlinked into place via installation scripts.
- **Core Tools:** Neovim, Tmux, Alacritty, Zsh.

## Build / Lint / Test Commands

### 1. Build & Installation

Since this is a dotfiles repository, there is no traditional compilation step. The "build" equivalent is running the installation scripts which symlink the configurations to their respective system locations:

- **macOS Installation:**
  ```bash
  ./install.sh
  ```
- **WSL2/Linux Installation:**
  ```bash
  ./install-wsl2-nix.sh
  ```

### 2. Linting

- **Shell Scripts (`.sh`, `.zshrc`, etc.):**
  ```bash
  # Check for common shell script errors
  shellcheck install.sh install-wsl2-nix.sh zsh/.zshrc
  ```

- **Neovim (Lua):**
  ```bash
  # Lint all Lua files
  luacheck nvim/init.lua nvim/lua/
  ```

- **Code Formatting:**
  Use `stylua` for Lua files. Format before committing.

### 3. Testing (Including "Single Test")

Because there is no formal test harness, testing is done by reloading the specific tool configuration manually.

**Running a "single test" for a specific component:**

- **Neovim:** Open nvim with the current config and check for errors or broken plugins.
  ```bash
  nvim
  # Test plugin loading without opening the UI
  nvim --headless -c "Lazy" -c "qa!"
  # Sync plugins to test package management
  nvim --headless -c "Lazy sync" -c "qa!"
  ```
  *(If lua test specs are ever added via busted/plenary, use: `nvim --headless -u init.lua -c "PlenaryBustedDirectory tests/ {minimal_init = init.lua}"`)*

- **Tmux:** Reload the config in an active session to test changes instantly.
  ```bash
  tmux source-file ~/.tmux.conf
  ```

- **Zsh:** Open a new shell or source the file to test aliases and prompts.
  ```bash
  zsh
  source ~/.zshrc
  ```

- **Install Scripts:** When modifying `install.sh`, test symlinking behavior locally or inside a Docker container to ensure idempotency.

## Code Style Guidelines

### 1. Shell Scripts (Bash / Zsh)

- **Formatting:** Use 2 spaces for indentation. No hard tabs.
- **Naming Conventions:**
  - Variables: `SNAKE_CASE` for global/environment variables, `snake_case` for local variables.
  - Functions: `snake_case` (e.g., `link_file() { ... }`).
- **Variables:** Always use `local` for variables inside functions to prevent global scope pollution.
- **Error Handling:**
  - Use `set -e` at the top of executable scripts to fail fast on errors.
  - Provide meaningful output using custom `info()`, `warn()`, `ok()` print functions (see `install.sh`).
- **Pathing:** Prefer absolute paths dynamically evaluated. Use `DOTFILES="$(cd "$(dirname "$0")" && pwd)"` to anchor paths.
- **Symlinking:** Use the custom `link()` function provided in `install.sh` to safely backup existing files before symlinking. Do not write raw `ln -s` commands.

### 2. Neovim / Lua Configuration (`nvim/`)

- **Formatting:** 2 spaces, Unix LF, no trailing whitespace.
- **Naming Conventions:**
  - Variables/Functions: `snake_case` (e.g., `local my_var = 1`).
  - Constants: `SCREAMING_SNAKE_CASE` (e.g., `local DEFAULT_OPTS`).
  - File Names: `snake_case` matching the plugin name (e.g., `rose-pine.lua`).
- **Module Structure (lazy.nvim):**
  - Keep `init.lua` as the simple entry point. It should only require core modules.
  - One file per plugin in `nvim/lua/plugins/`. Each must return a lazy.nvim spec table.
  - Avoid putting configuration inside `init.lua` directly.
- **Imports:**
  - Use `require("module_name")` for loading modules.
- **String Quotes:** Single quotes `' '` preferred, double quotes `" "` for multi-line strings.
- **Error Handling:**
  - ALWAYS use `pcall` when requiring plugins or executing potentially failing Neovim APIs to prevent startup crashes.
  ```lua
  local ok, module = pcall(require, "module.name")
  if not ok then
    vim.notify("Failed to load module.name", vim.log.levels.WARN)
    return
  end
  ```
- **API Usage:**
  - Settings: Use `vim.opt.setting = true` instead of `vim.cmd("set setting")`.
  - Keymaps: Use `vim.keymap.set` and always include a `desc` string for documentation.
- **Conventions:**
  - Space is the `<leader>` key.
  - Arrow keys are disabled by convention; prefer vim motions (`hjkl`).
  - Esc is remapped to `kk` in insert mode.

### 3. Alacritty (TOML)

- **Formatting:** Standard TOML spacing. 2 spaces for nested arrays/tables.
- **Structure:** `alacritty.toml` is the main entry point. Theme variants (e.g., `rose-pine.toml`) are kept separate and imported or symlinked. Keep configuration modular where supported.

### 4. Tmux

- **Conventions:** Prefix is remapped from `Ctrl+b` to `Ctrl+Space`.
- **Plugins:** TPM (Tmux Plugin Manager) is used.
- **Style:** Use comments to group related configurations (e.g., `# Plugins`, `# Keybindings`).
- **Status Bar:** Keep the status bar clean and aligned with the Rose Pine theme colors.

### 5. Git (`git/`)

- **Conventions:** Keep global ignores in `git/ignore`. Link `.gitconfig` to `~/.gitconfig`.
- **Commit Messages:** Use standard conventional commits format when possible.

## Agent Instructions & Rules

- **No Cursor/Copilot Rules:** There are currently no `.cursorrules` or `.github/copilot-instructions.md`. Rely solely on this document.
- **Proactiveness:** When updating a configuration file, remember that the user might need to reload their shell or editor. If you modify `install.sh`, ensure the same logic is mirrored in `install-wsl2-nix.sh` if applicable.
- **Themes:** Always default to Rose Pine for any new UI components. Check for existing theme variables before hardcoding colors.
- **File Edits:** If editing Neovim configs, follow the 1-plugin-per-file rule in `nvim/lua/plugins/`. Do not cram multiple plugins into one file.
- **Testing Assumptions:** Do not assume standard commands work out-of-the-box. Many CLI tools are installed via Homebrew or Nix, so check `install.sh` for dependencies.
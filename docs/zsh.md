# Zsh Configuration

## Overview

The Zsh configuration is split across four files in `zsh/`, each symlinked to the home directory:

| File         | Symlink Target   | Purpose                                    |
|-------------|------------------|--------------------------------------------|
| `.zshenv`    | `~/.zshenv`      | Environment variables loaded for every shell |
| `.zprofile`  | `~/.zprofile`    | Login shell setup (runs once on login)      |
| `.zshrc`     | `~/.zshrc`       | Interactive shell config (runs per session) |
| `.profile`   | `~/.profile`     | POSIX-compatible profile (for non-zsh shells)|

## Load Order

Zsh sources files in this order for a login interactive shell:

1. `.zshenv` -- Always loaded first
2. `.zprofile` -- Login shells only
3. `.zshrc` -- Interactive shells only

## .zshenv

Sets environment variables available to all shells (interactive and non-interactive):

| Variable | Value |
|----------|-------|
| Cargo    | Sources `$HOME/.cargo/env` (Rust toolchain) |
| Flutter  | Adds `$HOME/flutter/bin` to `PATH` |

## .zprofile

Runs once when a login shell starts:

- **Homebrew**: Initializes Homebrew shell environment (`/opt/homebrew/bin/brew shellenv`)
- **OrbStack**: Sources OrbStack CLI tools integration (if available)

## .zshrc

The main interactive shell configuration:

### Shell Integrations

| Tool       | Purpose                              |
|-----------|--------------------------------------|
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smarter `cd` command (`z` alias) |
| [starship](https://starship.rs/) | Cross-shell prompt |
| [fnm](https://github.com/Schniz/fnm) | Fast Node.js version manager (auto-switches on `cd`) |

### Language Toolchains

| Language   | Configuration                        |
|-----------|--------------------------------------|
| Go        | `GOPATH=$HOME/go`, adds Go bins to `PATH` |
| Deno      | Sources `$HOME/.deno/env`            |
| Node.js   | Managed by `fnm` (see shell integrations) |
| pnpm      | `PNPM_HOME=$HOME/Library/pnpm`, added to `PATH` |

### Other Tools

| Tool          | Path                                     |
|--------------|------------------------------------------|
| Antigravity  | `$HOME/.antigravity/antigravity/bin`     |

### Completions

- Deno completions added to `FPATH`
- Zsh built-in completions enabled via `compinit`

### Aliases

| Alias     | Command                                                       | Purpose |
|----------|---------------------------------------------------------------|---------|
| `gitvvs` | `git config --local credential.https://github.com.username vvsubash` | Set local Git credential for GitHub |

## .profile

POSIX-compatible profile for non-zsh login shells:

- Sources Deno environment
- Sources Cargo (Rust) environment

## Adding New Environment Variables

- For **all shells** (scripts, cron, etc.): Add to `.zshenv`
- For **login shells only**: Add to `.zprofile`
- For **interactive shells only**: Add to `.zshrc`

# Exit early for non-interactive shells to avoid running interactive-only init
[[ $- != *i* ]] && return

# Deno completions
if [[ ":$FPATH:" != *":$HOME/completions:"* ]]; then export FPATH="$HOME/completions:$FPATH"; fi

# Shell integrations (interactive only)
# Guard each integration to avoid errors when tool is missing
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi
if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
fi

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Deno
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# Zsh completions
autoload -Uz compinit
compinit

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;; 
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

# Aliases
alias gitvvs='git config --local credential.https://github.com.username vvsubash'

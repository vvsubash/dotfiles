# Deno completions
if [[ ":$FPATH:" != *":$HOME/completions:"* ]]; then export FPATH="$HOME/completions:$FPATH"; fi

# Shell integrations
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Deno
. "$HOME/.deno/env"

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

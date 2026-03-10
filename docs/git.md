# Git Configuration

## Overview

Git configuration is split into two files:

- `git/.gitconfig` -- User-level git settings, symlinked to `~/.gitconfig`
- `git/ignore` -- Global gitignore rules, symlinked to `~/.config/git/ignore`

## .gitconfig

### Credentials

Uses [Git Credential Manager](https://github.com/git-ecosystem/git-credential-manager) (GCM) for credential storage:

```ini
[credential]
    helper =
    helper = /usr/local/share/gcm-core/git-credential-manager
```

Azure DevOps is configured to use HTTP path-based authentication:

```ini
[credential "https://dev.azure.com"]
    useHttpPath = true
```

### User Identity

| Property | Value                    |
|----------|--------------------------|
| Email    | `venkat@shareplay.tv`    |
| Name     | `vvsubashshareplay`      |

### Init

- Default branch name: `main`

## Global Gitignore

The global ignore file (`git/ignore`) excludes:

```
**/.claude/settings.local.json
```

This prevents Claude AI local settings from being committed to any repository.

## Customization

To use a different identity for specific repos, run inside the repo:

```bash
git config --local user.email "your@email.com"
git config --local user.name "Your Name"
```

There is also an alias defined in `.zshrc` for switching to the `vvsubash` GitHub credential:

```bash
gitvvs  # sets local credential username to vvsubash for github.com
```

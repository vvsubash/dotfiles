# Tmux Configuration

## Overview

The tmux configuration lives in `tmux/.tmux.conf` and is symlinked to `~/.tmux.conf`.

## Prefix Key

The prefix key is changed from the default `Ctrl+b` to **`Ctrl+Space`**:

```
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix
```

## General Settings

| Setting        | Value   |
|---------------|---------|
| Mouse support | Enabled |
| Base index    | 1 (windows start numbering at 1) |
| Status bar    | Top     |

## Pane Navigation

Vim-style pane navigation using the prefix key:

| Binding            | Action        |
|-------------------|---------------|
| `Prefix + h`       | Move left     |
| `Prefix + j`       | Move down     |
| `Prefix + k`       | Move up       |
| `Prefix + l`       | Move right    |

## Config Reload

Reload the tmux configuration without restarting:

```
Prefix + r
```

## Plugins

Plugins are managed by [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm).

| Plugin              | Description              |
|--------------------|--------------------------|
| `rose-pine/tmux`    | Rose Pine theme (variant: `main`) |
| `tmux-plugins/tpm`  | Plugin manager           |

### Installing Plugins

TPM is installed automatically by the install script. To install plugins after adding them to `.tmux.conf`:

1. Open tmux
2. Press `Ctrl+Space + I` (capital I)

### Updating Plugins

Press `Ctrl+Space + U` (capital U) inside tmux.

## Quick Reference

| Action                  | Keys                    |
|------------------------|-------------------------|
| Reload config          | `Prefix + r`            |
| New window             | `Prefix + c`            |
| Split horizontal       | `Prefix + "`            |
| Split vertical         | `Prefix + %`            |
| Navigate panes         | `Prefix + h/j/k/l`     |
| Next window            | `Prefix + n`            |
| Previous window        | `Prefix + p`            |
| Kill pane              | `Prefix + x`            |
| Detach                 | `Prefix + d`            |
| Install plugins (TPM)  | `Prefix + I`            |

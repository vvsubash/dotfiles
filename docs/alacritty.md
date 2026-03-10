# Alacritty Configuration

## Overview

[Alacritty](https://alacritty.org/) is a GPU-accelerated terminal emulator. The configuration lives in `alacritty/alacritty.toml` and is symlinked to `~/.config/alacritty/alacritty.toml`.

## Font

| Property    | Value                       |
|------------|------------------------------|
| Family     | IosevkaTerm Nerd Font        |
| Size       | 14.0                         |
| Styles     | Regular, Bold, Italic, Bold Italic |

**Prerequisite:** Install [Iosevka Nerd Font](https://www.nerdfonts.com/) before using this config.

## Window

| Property        | Value      |
|----------------|------------|
| Padding        | 10px x 10px |
| Dynamic padding | Enabled    |
| Decorations    | Full       |
| Startup mode   | Windowed   |
| Opacity        | 0.95 (slight transparency) |

## Cursor

| Property          | Value        |
|------------------|--------------|
| Shape            | Block        |
| Blinking         | On           |
| Blink interval   | 750ms        |
| Unfocused hollow | Yes          |

## Scrolling

| Property   | Value  |
|-----------|--------|
| History   | 10,000 lines |
| Multiplier | 3      |

## Selection

- Automatically saves selections to the clipboard.

## Mouse

- Cursor hides when typing.

## Terminal Shell

- Shell: `/bin/zsh -l` (login shell)
- `TERM` environment variable set to `xterm-256color` for proper color support in tmux.

## Key Bindings

### General

| Binding          | Action            |
|-----------------|-------------------|
| `Ctrl+V`         | Paste             |
| `Ctrl+C`         | Copy              |
| `Shift+Insert`   | Paste selection   |
| `Ctrl+0`         | Reset font size   |
| `Ctrl+=`         | Increase font size|
| `Ctrl+-`         | Decrease font size|
| `F11`            | Toggle fullscreen |
| `Shift+Enter`    | Send `ESC + Enter` (useful for terminal apps) |

### Tmux Integration

| Binding          | Action                        |
|-----------------|-------------------------------|
| `Cmd+T`          | Spawn new Alacritty instance  |
| `Ctrl+B`         | Send tmux prefix (`Ctrl+B`)   |
| `Alt+Left`       | Tmux previous word / window   |
| `Alt+Right`      | Tmux next word / window       |

## Color Theme: Rose Pine

The active theme is **Rose Pine** (dark variant), imported via `rose-pine.toml`.

Three Rose Pine variants are included:

| File                  | Variant | Background |
|----------------------|---------|------------|
| `rose-pine.toml`      | Main    | `#191724` (dark) |
| `rose-pine-moon.toml` | Moon    | `#232136` (darker) |
| `rose-pine-dawn.toml` | Dawn    | `#faf4ed` (light) |

### Switching Themes

Edit `alacritty.toml` and change the import line:

```toml
[general]
import = ["rose-pine-moon.toml"]  # or "rose-pine-dawn.toml"
```

## Bell

- Animation: EaseOutExpo
- Duration: 0 (visual bell disabled)

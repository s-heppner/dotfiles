# Terminal Colors

The terminal color scheme is built on the [base16](https://github.com/chriskempson/base16)
system: a palette of 16 colors (`base00`–`base0F`) with well-defined roles.
Multiple palettes can be installed and switched at runtime; **Nord** is the
default, with **Everforest Dark Hard** shipped as a second example.

## Where things live

| What | Path |
| --- | --- |
| Palette definitions | `home/.config/base16/themes/<name>.sh` → `~/.config/base16/themes/` |
| Loader (bash) | `home/.bashrc_scripts/colors.sh` |
| Loader (tmux) | `mybin/base16-tmux`, wired up in `home/.tmux.conf` |
| Active palette (per machine) | `${XDG_STATE_HOME:-~/.local/state}/base16-theme` |

The palette directory is a normal, version-controlled dotfile; the *active
choice* is stored per machine outside the repo so switching never dirties it.

## Switching the palette

```bash
bash-color-theme            # or `list` — show installed palettes (* = active)
bash-color-theme current    # print the active palette name
bash-color-theme set nord   # switch (persists across shells)
bash-color-theme nord       # shorthand for `set`
```

Switching re-colors the current shell (prompt, `ls`) immediately and, if run
inside tmux, reloads the tmux status bar too.

## The 16 slots

Each palette file declares `BASE00`–`BASE0F` as 6-digit RGB hex (no `#`).
Roles follow the base16 styling guidelines:

| Slot | Role | Semantic `COLOR_*` |
| --- | --- | --- |
| `base00` | Default background | `COLOR_BACKGROUND` |
| `base01` | Lighter background (status bars) | — |
| `base02` | Selection background | — |
| `base03` | Comments, muted / grey accents | — |
| `base04` | Dark foreground | — |
| `base05` | Default foreground | `COLOR_TEXT` |
| `base06` | Light foreground | — |
| `base07` | Light background | — |
| `base08` | Red | `COLOR_RED` |
| `base09` | Orange | `COLOR_ORANGE` |
| `base0A` | Yellow | `COLOR_YELLOW` (alias `COLOR_GOLD`) |
| `base0B` | Green | `COLOR_GREEN` |
| `base0C` | Cyan | `COLOR_CYAN` |
| `base0D` | Blue | `COLOR_BLUE` |
| `base0E` | Purple | `COLOR_PURPLE` (alias `COLOR_MAGENTA`) |
| `base0F` | Brown | `COLOR_BROWN` |

In bash, every slot is also available raw as `COLOR_BASE00`…`COLOR_BASE0F`.
In tmux, every slot is a user option `#{@base16_00}`…`#{@base16_0F}`.

## Adding a palette

Drop a new file in `home/.config/base16/themes/`, e.g. `my-palette.sh`,
declaring all 16 slots as 6-digit RGB hex (the values below are placeholders):

```sh
# base16 my-palette
BASE00="000000"; BASE01="111111"; BASE02="222222"; BASE03="333333"
BASE04="cccccc"; BASE05="dddddd"; BASE06="eeeeee"; BASE07="ffffff"
BASE08="ff0000"; BASE09="ff8800"; BASE0A="ffff00"; BASE0B="00ff00"
BASE0C="00ffff"; BASE0D="0000ff"; BASE0E="ff00ff"; BASE0F="884400"
```

The file name (without `.sh`) is the palette name — use lowercase letters,
digits and hyphens only. It is picked up automatically; switch to it with
`bash-color-theme set my-palette`. Any base16 scheme can be used by filling in
its `base00`–`base0F` hex values; ready-made schemes are collected in
[tinted-theming/schemes](https://github.com/tinted-theming/schemes) (mind each
scheme's license before redistributing its values).

# base16 terminal theming
#
# (2026-07-05, s-heppner)
# Colors are defined as base16 palettes (base00..base0F). Each palette lives in
# its own data file at `~/.config/base16/themes/<name>.sh` and declares
# BASE00..BASE0F as 6-digit RGB hex. This loader turns the active palette into
# the ANSI escape variables (COLOR_*) used by the prompt and into LS_COLORS.
#
# Switch palette live with the `base16-color-scheme` command (see bottom of file).
# The active palette name persists per-machine in a small state file.

# --- Configuration ---------------------------------------------------------
# Where palettes live and where the active choice is remembered. Both honour a
# pre-set value (useful for testing) and fall back to XDG defaults. Plain
# assignment keeps this file safe to re-source.
BASE16_THEMES_DIR="${BASE16_THEMES_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/base16/themes}"
BASE16_STATE_FILE="${BASE16_STATE_FILE:-${XDG_STATE_HOME:-$HOME/.local/state}/base16-theme}"
_BCS_DEFAULT_THEME="nord"

# The 16 base16 slots, in order. Used for iteration.
_BCS_SLOTS="00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F"

# --- Helpers ---------------------------------------------------------------

# Convert a 6-digit hex color ("eceff4" or "#eceff4") to decimal "R;G;B",
# the form expected by ANSI 24-bit escapes and LS_COLORS.
_bcs_hex_to_rgb() {
    local hex="${1#\#}"
    printf '%d;%d;%d' "0x${hex:0:2}" "0x${hex:2:2}" "0x${hex:4:2}"
}

# List installed palette names (basename without .sh), one per line.
_bcs_list() {
    local file name
    [ -d "$BASE16_THEMES_DIR" ] || return 0
    for file in "$BASE16_THEMES_DIR"/*.sh; do
        [ -e "$file" ] || continue
        name="${file##*/}"
        printf '%s\n' "${name%.sh}"
    done
}

# Print the active palette name (from the state file, or the default).
_bcs_current() {
    local name
    if [ -r "$BASE16_STATE_FILE" ] && read -r name < "$BASE16_STATE_FILE" \
        && [ -n "$name" ]; then
        printf '%s\n' "$name"
    else
        printf '%s\n' "$_BCS_DEFAULT_THEME"
    fi
}

# Load palette <name> and rebuild every COLOR_* escape and LS_COLORS.
# Leaves the environment untouched and returns non-zero on any error
# (invalid name, missing file, incomplete palette).
_bcs_apply() {
    local name="$1" file slot i hexvar rgb

    # Validate the name: lowercase letters, digits and hyphens only. This also
    # blocks path traversal (no slashes, no dots) before touching the fs.
    if [[ ! "$name" =~ ^[a-z0-9-]+$ ]]; then
        printf 'base16: invalid theme name: %s\n' "$name" >&2
        return 1
    fi
    file="$BASE16_THEMES_DIR/$name.sh"
    if [ ! -r "$file" ]; then
        printf 'base16: theme not found: %s\n' "$file" >&2
        return 1
    fi

    # Source the palette into locals so the raw BASE* values never leak out.
    local BASE00 BASE01 BASE02 BASE03 BASE04 BASE05 BASE06 BASE07 \
          BASE08 BASE09 BASE0A BASE0B BASE0C BASE0D BASE0E BASE0F
    # shellcheck source=/dev/null
    source "$file"

    # Every slot must be defined, otherwise refuse the palette.
    for slot in $_BCS_SLOTS; do
        hexvar="BASE$slot"
        if [ -z "${!hexvar:-}" ]; then
            printf 'base16: theme %s is missing BASE%s\n' "$name" "$slot" >&2
            return 1
        fi
    done

    # Raw slots: COLOR_BASE00..COLOR_BASE0F as foreground escapes. We store the
    # literal "\e[...m" form (not a real ESC byte); the prompt and `echo -e`
    # expand it, matching the previous behaviour of this file.
    for slot in $_BCS_SLOTS; do
        hexvar="BASE$slot"
        rgb="$(_bcs_hex_to_rgb "${!hexvar}")"
        printf -v "COLOR_BASE$slot" '\\e[38;2;%sm' "$rgb"
    done

    # Semantic aliases, following the base16 styling guidelines.
    COLOR_BACKGROUND="\\e[48;2;$(_bcs_hex_to_rgb "$BASE00")m"
    COLOR_TEXT="$COLOR_BASE05"
    COLOR_RED="$COLOR_BASE08"
    COLOR_ORANGE="$COLOR_BASE09"
    COLOR_YELLOW="$COLOR_BASE0A"
    COLOR_GOLD="$COLOR_YELLOW"     # back-compat alias
    COLOR_GREEN="$COLOR_BASE0B"
    COLOR_CYAN="$COLOR_BASE0C"
    COLOR_BLUE="$COLOR_BASE0D"
    COLOR_PURPLE="$COLOR_BASE0E"
    COLOR_MAGENTA="$COLOR_PURPLE"  # alias
    COLOR_BROWN="$COLOR_BASE0F"
    COLOR_RESET='\e[0m'

    _bcs_apply_ls_colors "$BASE05" "$BASE09" "$BASE0A" "$BASE0C" "$BASE0D"
}

# Rebuild LS_COLORS for the `ls` command from the active palette.
# Args: <fg> <exec> <dir> <link> <orphan> hex values.
# LS_COLORS keys are separated by ':'. We start from the distro default and
# append our overrides (last value wins). Some keys:
#   di directory   fi file        ln symlink     bd/cd block/char device
#   or broken link ex executable  ow other-writable (WSL quirk)
_bcs_apply_ls_colors() {
    local fg="$1" exec="$2" dir="$3" link="$4" orphan="$5"
    local c_fg c_exec c_dir c_link c_orphan
    c_fg="38;2;$(_bcs_hex_to_rgb "$fg")"
    c_exec="38;2;$(_bcs_hex_to_rgb "$exec")"
    c_dir="38;2;$(_bcs_hex_to_rgb "$dir")"
    c_link="38;2;$(_bcs_hex_to_rgb "$link")"
    c_orphan="38;2;$(_bcs_hex_to_rgb "$orphan")"

    local default_ls='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.swp=00;90:*.tmp=00;90:*.dpkg-dist=00;90:*.dpkg-old=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:'

    LS_COLORS="${default_ls}:di=${c_dir}:fi=${c_fg}:ln=${c_link}:bd=${c_fg}:cd=${c_fg}:or=${c_orphan}:ex=${c_exec}:ow=${c_dir}"
    export LS_COLORS
}

# --- Public command --------------------------------------------------------

_bcs_usage() {
    cat <<'EOF'
base16-color-scheme — switch the active base16 terminal palette

usage:
  base16-color-scheme [list]        list installed palettes (* marks the active)
  base16-color-scheme current       print the active palette name
  base16-color-scheme set <name>    switch to <name> (persists across shells)
  base16-color-scheme <name>        shorthand for `set <name>`
  base16-color-scheme help          show this help

Palettes live in ~/.config/base16/themes/<name>.sh
EOF
}

# Apply <name>, persist it, and refresh anything that caches colors.
_bcs_set() {
    local name="$1"
    _bcs_apply "$name" || return 1

    mkdir -p "$(dirname "$BASE16_STATE_FILE")" \
        && printf '%s\n' "$name" > "$BASE16_STATE_FILE" \
        || { printf 'base16: could not persist theme choice\n' >&2; return 1; }

    # The prompt embeds the escape codes by value, so rebuild it live if
    # .bashrc exposed the builder.
    if declare -F set_bash_prompt >/dev/null; then
        set_bash_prompt
    fi

    # Re-color a running tmux, if any, from the same palette.
    if [ -n "${TMUX:-}" ] && command -v tmux >/dev/null 2>&1; then
        tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1
    fi

    printf 'base16: theme set to %s\n' "$name"
}

base16-color-scheme() {
    local cmd="${1:-list}"
    case "$cmd" in
        list|ls)
            local current theme
            current="$(_bcs_current)"
            while IFS= read -r theme; do
                if [ "$theme" = "$current" ]; then
                    printf '* %s\n' "$theme"
                else
                    printf '  %s\n' "$theme"
                fi
            done < <(_bcs_list)
            ;;
        current)
            _bcs_current
            ;;
        set)
            if [ -z "${2:-}" ]; then
                printf 'usage: base16-color-scheme set <name>\n' >&2
                return 2
            fi
            _bcs_set "$2"
            ;;
        help|-h|--help)
            _bcs_usage
            ;;
        *)
            # Shorthand: `base16-color-scheme <name>` == `set <name>`.
            _bcs_set "$cmd"
            ;;
    esac
}

# Tab-completion: subcommands at position 1, palette names after `set`.
_bcs_complete() {
    local cur="${COMP_WORDS[COMP_CWORD]}"
    local prev="${COMP_WORDS[COMP_CWORD-1]}"
    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "list current set help $(_bcs_list)" -- "$cur") )
    elif [ "$prev" = "set" ]; then
        COMPREPLY=( $(compgen -W "$(_bcs_list)" -- "$cur") )
    fi
}
complete -F _bcs_complete base16-color-scheme

# --- ls / grep color aliases -----------------------------------------------
# (2023-08-29, s-heppner)
# Enable color support of ls and add handy aliases. LS_COLORS itself is set by
# _bcs_apply below (this only wires up the aliases and dircolors database).
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# --- Activate the current palette ------------------------------------------
# Fall back to the default if the persisted palette is unavailable.
_bcs_apply "$(_bcs_current)" || _bcs_apply "$_BCS_DEFAULT_THEME"

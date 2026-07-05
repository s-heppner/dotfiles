# base16 dune-light
# base16 palette. Data only: this file is sourced by the theme loader in
# `.bashrc_scripts/colors.sh` and by `base16-tmux`. It must not have side
# effects — only declare BASE00..BASE0F as 6-digit RGB hex (no leading '#').
#
# Note: a *light* palette — the background slots (base00..base07) run light to
# dark, the reverse of the dark themes.
BASE00="fefbec"  # Default background
BASE01="e8e4cf"  # Lighter background (status bars, line highlight)
BASE02="a6a28c"  # Selection background
BASE03="999580"  # Comments, invisibles, line highlight
BASE04="7d7a68"  # Dark foreground (status bars)
BASE05="6e6b5e"  # Default foreground
BASE06="292824"  # Light foreground
BASE07="20201d"  # Light background
BASE08="d73737"  # Red   — variables, errors, diff deleted
BASE09="b65611"  # Orange — integers, constants
BASE0A="ae9513"  # Yellow — classes, search highlight
BASE0B="60ac39"  # Green  — strings, diff inserted
BASE0C="1fad83"  # Cyan   — support, escapes, regex
BASE0D="6684e1"  # Blue   — functions, methods
BASE0E="b854d4"  # Purple — keywords
BASE0F="d43552"  # Brown  — deprecated, embedded punctuation

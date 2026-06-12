#!/usr/bin/env bash
# install.sh — install hardline, its man page and shell completions.
#
#   sudo ./install.sh           # system-wide (/usr/local)
#   PREFIX=~/.local ./install.sh # user-local (no root)
set -euo pipefail

PREFIX="${PREFIX:-/usr/local}"
HERE="$(cd "$(dirname "$0")" && pwd)"

install -Dm755 "$HERE/hardline" "$PREFIX/bin/hardline"
install -Dm644 "$HERE/hardline.1" "$PREFIX/share/man/man1/hardline.1"
install -Dm644 "$HERE/completions/hardline.bash" "$PREFIX/share/bash-completion/completions/hardline"
install -Dm644 "$HERE/completions/hardline.fish" "$PREFIX/share/fish/vendor_completions.d/hardline.fish"
install -Dm644 "$HERE/completions/_hardline" "$PREFIX/share/zsh/site-functions/_hardline"

echo "installed hardline → $PREFIX/bin/hardline"
echo "  man:         man hardline"
echo "  completions: bash · fish · zsh (restart your shell)"

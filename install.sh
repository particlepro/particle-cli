#!/bin/sh
# Install the particle CLI: curl -LsSf https://cli.particle.pro/install.sh | sh
#
# Downloads and runs the installer from the newest release at
# https://github.com/particlepro/particle-cli/releases/latest, then sets up
# tab completion and says what to run next.
# Options are environment variables, for example:
#   PARTICLE_CLI_INSTALL_DIR=~/bin           install somewhere else
#   PARTICLE_CLI_NO_MODIFY_PATH=1            don't edit shell profiles (no PATH line, no completion)
set -eu

url="https://github.com/particlepro/particle-cli/releases/latest/download/particle-cli-installer.sh"
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT INT TERM

if command -v curl >/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -LsSf "$url" -o "$tmp"
elif command -v wget >/dev/null 2>&1; then
  wget --https-only -q "$url" -O "$tmp"
else
  echo "install.sh: curl or wget is required" >&2
  exit 1
fi

# Where the binary goes: dist's installer honors PARTICLE_CLI_INSTALL_DIR,
# else the first of $XDG_BIN_HOME, $XDG_DATA_HOME/../bin, ~/.local/bin.
if [ -n "${PARTICLE_CLI_INSTALL_DIR:-}" ]; then
  dir="$PARTICLE_CLI_INSTALL_DIR"
elif [ -n "${XDG_BIN_HOME:-}" ]; then
  dir="$XDG_BIN_HOME"
elif [ -n "${XDG_DATA_HOME:-}" ]; then
  dir="$XDG_DATA_HOME/../bin"
else
  dir="$HOME/.local/bin"
fi
bin="$dir/particle"
before=""
if [ -x "$bin" ]; then
  before="$("$bin" --version 2>/dev/null | head -n 1 | awk '{print $2}')" || before=""
fi

sh "$tmp" "$@"

if [ ! -x "$bin" ]; then
  exit 0
fi
after="$("$bin" --version 2>/dev/null | head -n 1 | awk '{print $2}')" || after=""
echo
if [ -z "$before" ]; then
  echo "particle $after installed in $dir"
elif [ "$before" = "$after" ]; then
  echo "particle $after is already the newest version"
else
  echo "particle upgraded: $before → $after (what changed: https://github.com/particlepro/particle-cli/releases)"
fi

if [ -z "${PARTICLE_CLI_NO_MODIFY_PATH:-}" ]; then
  # Older releases have no `completion install`; that's fine.
  if out="$("$bin" completion install </dev/null 2>&1)"; then
    echo "$out"
  fi
fi

if [ -z "$before" ]; then
  cat <<'NEXT'

Next:
  particle auth login     # sign in (or sign up) in your browser
  particle doctor         # check the setup
  particle                # common commands and examples
NEXT
fi

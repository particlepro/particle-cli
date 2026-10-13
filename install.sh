#!/bin/sh
# Install the particle CLI: curl -LsSf https://cli.particle.pro/install.sh | sh
#
# Downloads and runs the installer from the newest release at
# https://github.com/particlepro/particle-cli/releases/latest
# Options are environment variables, for example:
#   PARTICLE_CLI_INSTALL_DIR=~/bin           install somewhere else
#   PARTICLE_CLI_NO_MODIFY_PATH=1            don't edit shell profiles
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

sh "$tmp" "$@"

# particle CLI releases

Release binaries and installers for **`particle`**, the command-line interface for the [Particle API](https://docs.particle.pro): podcast transcripts, mentions, guests, rankings, sponsors, companies, and people.

## Install

```sh
# macOS and Linux (Homebrew)
brew install particlepro/tap/particle

# macOS and Linux (shell installer)
curl -LsSf https://github.com/particlepro/particle-cli-releases/releases/latest/download/particle-cli-installer.sh | sh

# Windows (PowerShell)
powershell -ExecutionPolicy Bypass -c "irm https://github.com/particlepro/particle-cli-releases/releases/latest/download/particle-cli-installer.ps1 | iex"
```

Then:

```sh
particle stats          # works without a key
particle auth login     # paste a key from https://platform.particle.pro/tokens
particle                # common commands and examples
```

Each [release](https://github.com/particlepro/particle-cli-releases/releases) has archives for every platform, with SHA-256 checksums.

This repository only hosts releases. Questions or problems: api@particle.pro.

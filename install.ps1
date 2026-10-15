# Install the particle CLI on Windows:
#   powershell -ExecutionPolicy Bypass -c "irm https://cli.particle.pro/install.ps1 | iex"
# Runs the installer from the newest release at
# https://github.com/particlepro/particle-cli/releases/latest
# Options are environment variables, for example:
#   $env:PARTICLE_CLI_INSTALL_DIR = "$HOME\bin"    install somewhere else
#   $env:PARTICLE_CLI_NO_MODIFY_PATH = 1           don't add it to PATH
$ErrorActionPreference = 'Stop'
Invoke-RestMethod 'https://github.com/particlepro/particle-cli/releases/latest/download/particle-cli-installer.ps1' | Invoke-Expression

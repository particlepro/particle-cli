# Install the particle CLI on Windows:
#   powershell -ExecutionPolicy Bypass -c "irm https://cli.particle.pro/install.ps1 | iex"
# Runs the installer from the newest release at
# https://github.com/particlepro/particle-cli-releases/releases/latest
$ErrorActionPreference = 'Stop'
Invoke-RestMethod 'https://github.com/particlepro/particle-cli-releases/releases/latest/download/particle-cli-installer.ps1' | Invoke-Expression

#!/usr/bin/env bash
set -euo pipefail

keyring='/usr/share/keyrings/claude-desktop-archive-keyring.asc'
source_list='/etc/apt/sources.list.d/claude-desktop.list'
repo='https://downloads.claude.ai/claude-desktop/apt/stable'

if ! command -v sudo >/dev/null 2>&1; then
  printf 'sudo is required to install Claude Desktop through apt.\n' >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  sudo apt update
  sudo apt install -y curl ca-certificates
fi

sudo install -d -m 0755 /usr/share/keyrings
sudo curl -fsSLo "${keyring}" "${repo%/apt/stable}/key.asc"

printf 'deb [arch=amd64,arm64 signed-by=%s] %s stable main\n' "${keyring}" "${repo}" |
  sudo tee "${source_list}" >/dev/null

sudo apt update
sudo apt install -y claude-desktop

# Debian and Ubuntu

This directory follows Anthropic's official installation instructions for
Claude Desktop on Ubuntu and Debian.

## Install

```sh
./install.sh
```

The script:

1. Downloads Anthropic's apt signing key.
2. Adds Anthropic's stable Claude Desktop apt repository.
3. Runs `apt update`.
4. Installs `claude-desktop`.

## Update

Claude Desktop updates through normal apt upgrades:

```sh
sudo apt update && sudo apt upgrade
```

## Uninstall

```sh
sudo apt remove claude-desktop
sudo rm -f /etc/apt/sources.list.d/claude-desktop.list
sudo rm -f /usr/share/keyrings/claude-desktop-archive-keyring.asc
```

## Upstream

See Anthropic's official Linux documentation:

https://code.claude.com/docs/en/desktop-linux

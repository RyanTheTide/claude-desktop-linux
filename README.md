# Claude Desktop Linux

Community packaging helpers for Anthropic's official Claude Desktop Linux beta.

Anthropic currently publishes an official Debian package and apt repository for
Ubuntu and Debian. This repository keeps the official Debian flow intact and
adds community packaging for Arch Linux and Fedora.

## Packages

| Distribution | Directory | Status |
| --- | --- | --- |
| Arch Linux | [`arch`](arch/) | GitHub-hosted `claude-desktop` PKGBUILD; AUR package remains `claude` |
| Fedora | [`fedora`](fedora/) | Local `claude-desktop` RPM build from the official Debian package |
| Debian / Ubuntu | [`debian`](debian/) | Official Anthropic apt repository installer |

## Architectures

The Arch and Fedora packaging supports:

- `x86_64`
- `aarch64`

The upstream Debian package supports:

- `amd64`
- `arm64`

## Cowork virtualization

Claude Desktop's Cowork feature needs local virtualization support. The Arch and
Fedora packages depend on native QEMU, firmware, and `virtiofsd` packages for
their target distributions.

If Cowork still reports that virtualization is not fully set up after install,
check the host kernel devices:

```sh
test -e /dev/kvm
test -e /dev/vhost-vsock || sudo modprobe vhost_vsock
```

Then restart Claude Desktop.

## Redistribution note

These package recipes download Anthropic's official artifacts at build or
install time. They do not redistribute Claude Desktop binaries. The GitHub
Arch, Fedora, and Debian packages are named `claude-desktop`; the AUR package
remains `claude` because another AUR package already owns the `claude-desktop`
package name.

Claude Desktop is proprietary software owned by Anthropic. Review Anthropic's
terms before using or redistributing packaging that installs it.

## Upstream docs

- [Claude Desktop on Linux beta](https://code.claude.com/docs/en/desktop-linux)
- [Claude download page](https://claude.com/download)

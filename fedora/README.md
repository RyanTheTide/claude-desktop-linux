# claude RPM packaging

Fedora RPM packaging for Anthropic's official Claude Desktop Linux beta `.deb`.

## Build

On Fedora:

```sh
sudo dnf install rpm-build rpmdevtools binutils bsdtar curl
./build-rpm.sh
```

The resulting RPM will be under:

```sh
rpmbuild/RPMS/
```

Install it with:

```sh
sudo dnf install ./rpmbuild/RPMS/$(uname -m)/claude-*.rpm
```

## Cowork dependencies

The RPM requires Fedora packages that match Claude's Linux preflight:

- `x86_64`: `qemu-system-x86-core`, `edk2-ovmf`, `virtiofsd`
- `aarch64`, including Fedora Asahi: `qemu-system-aarch64-core`, `edk2-aarch64`, `virtiofsd`

If Cowork still reports that virtualization is not set up:

```sh
test -e /dev/kvm
test -e /dev/vhost-vsock || sudo modprobe vhost_vsock
```

Then restart Claude.

## Updating

```sh
./update-spec.sh
./build-rpm.sh
```

The helper downloads Anthropic's official `.deb` during the local build and
verifies it against the SHA256 published in Anthropic's apt repository metadata.

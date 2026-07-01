#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
spec="${1:-${script_dir}/claude.spec}"
topdir="${RPM_TOPDIR:-${script_dir}/rpmbuild}"

need() {
  if ! command -v "$1" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$1" >&2
    exit 1
  fi
}

need awk
need curl
need rpmbuild
need sha256sum

version="$(awk '/^Version:/ { print $2; exit }' "${spec}")"
rpm_arch="$(uname -m)"

case "${rpm_arch}" in
  x86_64)
    deb_arch='amd64'
    source_name="claude-desktop_${version}_${deb_arch}.deb"
    sha="$(awk '/^%global sha256_x86_64 / { print $3; exit }' "${spec}")"
    ;;
  aarch64)
    deb_arch='arm64'
    source_name="claude-desktop_${version}_${deb_arch}.deb"
    sha="$(awk '/^%global sha256_aarch64 / { print $3; exit }' "${spec}")"
    ;;
  *)
    printf 'Unsupported architecture: %s\n' "${rpm_arch}" >&2
    exit 1
    ;;
esac

mkdir -p "${topdir}"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS}
cp "${spec}" "${topdir}/SPECS/claude.spec"

url="https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/${source_name}"
if [[ ! -f "${topdir}/SOURCES/${source_name}" ]]; then
  curl -fL "${url}" -o "${topdir}/SOURCES/${source_name}"
fi

printf '%s  %s\n' "${sha}" "${topdir}/SOURCES/${source_name}" | sha256sum -c -

rpmbuild -bb \
  --define "_topdir ${topdir}" \
  "${topdir}/SPECS/claude.spec"

printf '\nBuilt RPMs:\n'
find "${topdir}/RPMS" -type f -name '*.rpm' -print

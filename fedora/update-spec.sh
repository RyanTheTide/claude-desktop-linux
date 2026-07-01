#!/usr/bin/env bash
set -euo pipefail

repo='https://downloads.claude.ai/claude-desktop/apt/stable'
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
spec="${1:-${script_dir}/claude.spec}"

latest_for_arch() {
  local deb_arch="$1"
  curl -fsSL "${repo}/dists/stable/main/binary-${deb_arch}/Packages" |
    awk '
      BEGIN { RS=""; FS="\n" }
      /Package: claude-desktop/ {
        version = sha256 = ""
        for (i = 1; i <= NF; i++) {
          if ($i ~ /^Version: /) { sub(/^Version: /, "", $i); version = $i }
          if ($i ~ /^SHA256: /) { sub(/^SHA256: /, "", $i); sha256 = $i }
        }
        print version "\t" sha256
      }
    ' |
    sort -V |
    tail -n1
}

amd64="$(latest_for_arch amd64)"
arm64="$(latest_for_arch arm64)"

amd64_ver="${amd64%%$'\t'*}"
arm64_ver="${arm64%%$'\t'*}"
amd64_sha="${amd64##*$'\t'}"
arm64_sha="${arm64##*$'\t'}"

if [[ "${amd64_ver}" != "${arm64_ver}" ]]; then
  printf 'Version mismatch: amd64=%s arm64=%s\n' "${amd64_ver}" "${arm64_ver}" >&2
  exit 1
fi

current_ver="$(awk '/^Version:/ { print $2; exit }' "${spec}")"

sed -i \
  -e "s/^Version:.*/Version:        ${amd64_ver}/" \
  -e "s/^%global sha256_x86_64 .*/%global sha256_x86_64 ${amd64_sha}/" \
  -e "s/^%global sha256_aarch64 .*/%global sha256_aarch64 ${arm64_sha}/" \
  "${spec}"

if [[ "${current_ver}" != "${amd64_ver}" ]]; then
  sed -i -e 's/^Release:.*/Release:        1%{?dist}/' "${spec}"
fi

printf 'Updated %s to %s\n' "${spec}" "${amd64_ver}"

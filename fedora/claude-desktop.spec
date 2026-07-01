%global debug_package %{nil}
%global _missing_build_ids_terminate_build 0
%global claude_libdir %{_prefix}/lib/claude-desktop
%global sha256_x86_64 f4bd78545200877b591179838de7ad7a577df6ed2e845969dd25690efc5c85c7
%global sha256_aarch64 658acbff14bd9c35d795ede46f097fca79d433ac4af792cdd6486acd3adc6f2e

Name:           claude-desktop
Version:        1.17377.1
Release:        1%{?dist}
Summary:        Desktop application for Claude.ai, repackaged from the official Debian package

License:        LicenseRef-Proprietary
URL:            https://claude.ai
ExclusiveArch:  x86_64 aarch64
AutoReqProv:    no

%ifarch x86_64
Source0:        https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_%{version}_amd64.deb
%endif
%ifarch aarch64
Source0:        https://downloads.claude.ai/claude-desktop/apt/stable/pool/main/c/claude-desktop/claude-desktop_%{version}_arm64.deb
%endif

BuildRequires:  binutils
BuildRequires:  bsdtar

Requires:       at-spi2-core
Requires:       ca-certificates
Requires:       glib2
Requires:       glibc
Requires:       gtk3
Requires:       libdrm
Requires:       libnotify
Requires:       libsecret
Requires:       libX11
Requires:       libxcb
Requires:       libXtst
Requires:       mesa-libgbm
Requires:       nss
Requires:       util-linux
Requires:       xdg-desktop-portal
Requires:       xdg-utils
Requires:       virtiofsd

%ifarch x86_64
Requires:       edk2-ovmf
Requires:       qemu-system-x86-core
%endif
%ifarch aarch64
Requires:       edk2-aarch64
Requires:       qemu-system-aarch64-core
%endif

Recommends:     gnome-keyring
Recommends:     libayatana-appindicator-gtk3
Recommends:     pipewire-pulseaudio
Recommends:     xdg-desktop-portal-gnome
Recommends:     xdg-desktop-portal-gtk
Suggests:       kwallet
Suggests:       xdg-desktop-portal-kde

Provides:       claude = %{version}-%{release}
Obsoletes:      claude < %{version}-%{release}

%description
Claude Desktop packaged for Fedora from Anthropic's official Debian package.
The package depends on Fedora's QEMU, firmware, and virtiofsd packages so
Claude Cowork can pass its Linux virtualization preflight on x86_64 and
aarch64 systems, including Asahi Linux.

%prep
%setup -q -c -T
cp -p %{SOURCE0} claude-desktop.deb
ar x claude-desktop.deb
mkdir root
bsdtar --no-same-owner -xf data.tar.* -C root

%build

%install
mkdir -p %{buildroot}
cp -a root/. %{buildroot}/

chmod 4755 %{buildroot}%{claude_libdir}/chrome-sandbox

rm -rf \
  %{buildroot}/etc/apt \
  %{buildroot}%{_datadir}/keyrings \
  %{buildroot}%{_datadir}/lintian \
  %{buildroot}%{_prefix}/src

%post
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t -f %{_datadir}/icons/hicolor || :
fi
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q %{_datadir}/applications || :
fi

%postun
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t -f %{_datadir}/icons/hicolor || :
fi
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q %{_datadir}/applications || :
fi

%files
%license %{_datadir}/doc/claude-desktop/copyright
%{_bindir}/claude-desktop
%{claude_libdir}/
%{_datadir}/applications/claude-desktop.desktop
%{_datadir}/icons/hicolor/*/apps/claude-desktop.png

%changelog
* Wed Jul 01 2026 RyanTheTide <ryanthetide@gmail.com> - 1.17377.1-1
- Initial Fedora package from Anthropic's official Debian package

Name:       libreconvert
Version:    1.0.0
Release:    1%{?dist}
Summary:    An offline file converter application

License:    MIT
URL:        https://github.com/yourusername/libreconvert
Source0:    %{name}-%{version}-bin.tar.gz

BuildRequires:  desktop-file-utils
Requires:       ffmpeg
Requires:       pandoc
Requires:       ImageMagick

%define debug_package %{nil}

%description
libreconvert is a powerful, offline-first file converter application built with Flutter for desktop platforms. It supports a wide range of file types including images, audio, video, and documents, leveraging system-installed tools like FFmpeg, Pandoc, and ImageMagick for conversions.

%prep
%setup -q

%build
# No build steps needed as we are packaging a pre-built binary

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_bindir}
mkdir -p %{buildroot}%{_datadir}/%{name}
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_datadir}/icons/hicolor/256x256/apps

# Copy the bundled application files
cp -r ./* %{buildroot}%{_datadir}/%{name}/

# Create a symbolic link to the executable
ln -s %{_datadir}/%{name}/libreconvert %{buildroot}%{_bindir}/libreconvert

# Fix RPATH issues
find %{buildroot}%{_datadir}/%{name}/lib -name "*.so" -exec patchelf --remove-rpath {} \;

# Install the desktop file
cat << EOF > %{buildroot}%{_datadir}/applications/libreconvert.desktop
[Desktop Entry]
Name=LibreConvert
Comment=Offline file converter
Exec=libreconvert
Icon=%{_datadir}/icons/hicolor/256x256/apps/libreconvert.png
Terminal=false
Type=Application
Categories=Utility;
StartupWMClass=dev.libretools.convert.libreconvert
EOF

# Install the application icon
cp %{buildroot}%{_datadir}/%{name}/data/flutter_assets/assets/logo.png %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/libreconvert.png

%files
%{_bindir}/libreconvert
%{_datadir}/%{name}
%{_datadir}/applications/libreconvert.desktop
%{_datadir}/icons/hicolor/256x256/apps/libreconvert.png

%changelog
* Sat Jun 28 2025 LibreTools <libretools@protonmail.com> - 1.0.0-1
- Initial RPM release
# Building Linux Packages for LibreConvert

This document outlines the steps to build `.deb` (Debian/Ubuntu), `.rpm` (Fedora/RHEL), and `.pkg.tar.zst` (Arch Linux) packages for the LibreConvert application using `fpm`.

## Prerequisites

Before you begin, ensure you have the following installed:

1.  **Flutter SDK**: Follow the official Flutter installation guide for your operating system.
2.  **fpm**: A versatile tool for building packages. You can install it using RubyGems:
    ```bash
    sudo apt install ruby-dev # For Debian/Ubuntu
    sudo dnf install ruby-devel # For Fedora
    sudo pacman -S ruby # For Arch Linux
    sudo gem install fpm
    ```

## Building the Packages

Follow these steps to generate the Linux packages:

### 1. Clean and Build the Flutter Project

First, clean any previous Flutter builds and then build the application for Linux in release mode.

```bash
flutter clean && flutter build linux --release
```

### 2. Prepare the Staging Directory

Create a temporary directory structure that mimics the target installation paths on the user's system. This includes `/opt/libreconvert` for the application bundle, `/usr/local/bin` for the executable wrapper, and `/usr/share/applications` and `/usr/share/icons` for desktop integration.

```bash
mkdir -p packaging/opt/libreconvert packaging/usr/local/bin packaging/usr/share/applications packaging/usr/share/icons
```

### 3. Copy Application Bundle

Copy the built Flutter application bundle into the `/opt/libreconvert` directory within your staging area.

```bash
cp -r build/linux/x64/release/bundle/* packaging/opt/libreconvert/
```

### 4. Create the Executable Wrapper Script

Flutter applications require shared libraries that are bundled within the application directory. To ensure the system can find these libraries, create a wrapper script that sets the `LD_LIBRARY_PATH` environment variable before executing the main binary. This script will be placed in `/usr/local/bin`.

```bash
echo '#!/bin/bash
export LD_LIBRARY_PATH="/opt/libreconvert/lib:$LD_LIBRARY_PATH"
exec "/opt/libreconvert/libreconvert" "$@"' > packaging/usr/local/bin/libreconvert
```

### 5. Set Executable Permissions for the Wrapper Script

Make the wrapper script executable.

```bash
chmod +x packaging/usr/local/bin/libreconvert
```

### 6. Copy Desktop Entry and Icon

Copy the `.desktop` file and the application icon to their respective locations in the staging directory.

```bash
cp libreconvert.desktop packaging/usr/share/applications/libreconvert.desktop
cp assets/app.png packaging/usr/share/icons/hicolor/512x512/apps/libreconvert.png
```

### 7. Generate Packages using fpm

Finally, use `fpm` to create the `.deb`, `.rpm`, and `.pkg.tar.zst` packages from the prepared staging directory.

```bash
fpm -s dir -t deb -n libreconvert -v 1.0.1 --iteration 1 \
  --description "A powerful, offline-first file converter application built with Flutter for desktop platforms." \
  --url "https://libretools.dev/libreconvert" \
  --maintainer "LibreTools <raja@libretools.dev>" \
  --license "MIT" -C packaging .

fpm -s dir -t rpm -n libreconvert -v 1.0.1 --iteration 1 \
  --description "A powerful, offline-first file converter application built with Flutter for desktop platforms." \
  --url "https://libretools.dev/libreconvert" \
  --maintainer "LibreTools <raja@libretools.dev>" \
  --license "MIT" -C packaging .

fpm -s dir -t pacman -n libreconvert -v 1.0.1 --iteration 1 \
  --description "A powerful, offline-first file converter application built with Flutter for desktop platforms." \
  --url "https://libretools.dev/libreconvert" \
  --maintainer "LibreTools <raja@libretools.dev>" \
  --license "MIT" -C packaging .
```

After these steps, you will find the generated `.deb`, `.rpm`, and `.pkg.tar.zst` package files in your current working directory.

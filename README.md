# libreconvert

**libreconvert** is a powerful, offline-first file converter application built with Flutter for desktop platforms. It supports a wide range of file types including images, audio, video, and documents, leveraging system-installed tools like FFmpeg, Pandoc, and ImageMagick for conversions.

## Support

If you find this project useful, consider supporting it by buying me a coffee:

[![Buy me a coffee](https://img.buymeacoffee.com/button-api/?text=Buy%20me%20a%20coffee&emoji=&slug=libretools&button_colour=FFDD00&font_colour=000000&font_family=Cookie&outline_colour=000000&coffee_colour=ffffff)](https://www.buymeacoffee.com/libretools)

## Overview

libreconvert is designed to provide a user-friendly experience for converting files locally on your desktop, ensuring privacy and accessibility without requiring an internet connection. The application features a clean GUI for selecting files, choosing output formats, monitoring conversion progress, and configuring advanced settings.

## Core Features

- **File Selection**: Select single or multiple files for conversion using native file dialogs.
- **Format Selection**: Choose target formats from dropdowns or selection widgets based on file type.
- **Conversion Processing**: Perform conversions locally using ImageMagick for images, FFmpeg for audio/video, and Pandoc for documents.
- **Progress Feedback**: View conversion progress and results for each file.
- **Batch Processing**: Convert multiple files simultaneously with Dart's isolates for concurrency.

## Supported Formats

- **Images**: PNG, JPG, BMP, GIF, WEBP, HEIC, TIFF, and many more supported by ImageMagick.
- **Audio & Video**: MP4, MKV, AVI, MOV, WMV, FLV, MP3, WAV, FLAC, OGG, AAC, M4A, and other formats supported by FFmpeg.
- **Documents**: Markdown, HTML, PDF, DOCX, ODT, RTF, TXT, EPUB, and other formats supported by Pandoc.

## Getting Started

### Prerequisites

LibreConvert relies on external command-line tools for its conversion capabilities. Please ensure you have the following tools installed on your system for full functionality:

#### 1. FFmpeg (for Audio & Video Conversions)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install ffmpeg
    ```

- **Linux (Fedora):**

    ```bash
    sudo dnf install ffmpeg
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S ffmpeg
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install ffmpeg
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install ffmpeg
    ```

    (Alternatively, download from [ffmpeg.org](https://ffmpeg.org/download.html) and add to PATH.)

#### 2. ImageMagick (for Image Conversions)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install imagemagick
    ```

- **Linux (Fedora):**

    ```bash
    sudo dnf install ImageMagick
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S imagemagick
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install imagemagick
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install imagemagick
    ```

    (Alternatively, download from [imagemagick.org](https://imagemagick.org/script/download.php) and add to PATH.)

#### 3. Pandoc (for Document Conversions)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install pandoc
    ```

- **Linux (Fedora):**

    ```bash
    sudo dnf install pandoc
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S pandoc
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install pandoc
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install pandoc
    ```

    (Alternatively, download from [pandoc.org](https://pandoc.org/installing.html) and add to PATH.)

#### 4. TeX Live (for Advanced Document Conversions, e.g., PDF output from Pandoc)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install texlive-full # Installs a comprehensive TeX Live distribution
    ```

    (For a smaller installation, consider `texlive-latex-extra` and `texlive-fonts-recommended`.)
- **Linux (Fedora):**

    ```bash
    sudo dnf install texlive-scheme-full
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S texlive-most
    ```

- **macOS:** Install [MacTeX](https://www.tug.org/mactex/).

- **Windows:** Install [MiKTeX](https://miktex.org/download) or [TeX Live](https://www.tug.org/texlive/acquire-iso.html).

#### 5. `xdg-desktop-portal` and `zenity` (for File Picker on Arch Linux)

For the file picker to function correctly on Arch-based distributions, you may need `xdg-desktop-portal` and `zenity`.

- **Install `xdg-desktop-portal`:**

    ```bash
    sudo pacman -S xdg-desktop-portal
    ```

- **Install a backend specific to your desktop environment (e.g., for GNOME/GTK):**

    ```bash
    sudo pacman -S xdg-desktop-portal-gtk
    ```

    (Replace `xdg-desktop-portal-gtk` with `xdg-desktop-portal-kde` for KDE, etc.)

- **Install `zenity`:**

    ```bash
    sudo pacman -S zenity
    ```

---

### Installation

1. Clone the repository:

    ```bash
    git clone https://github.com/libre-tools/libreconvert.git
    cd libreconvert
    ```

2. Install Flutter dependencies:

    ```bash
    flutter pub get
    ```

3. Run the application:

    ```bash
    flutter run -d linux  # or -d macos, -d windows depending on your platform
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install ffmpeg
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install ffmpeg
    ```

    (Alternatively, download from [ffmpeg.org](https://ffmpeg.org/download.html) and add to PATH.)

#### 2. ImageMagick (for Image Conversions)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install imagemagick
    ```

- **Linux (Fedora):**

    ```bash
    sudo dnf install ImageMagick
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S imagemagick
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install imagemagick
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install imagemagick
    ```

    (Alternatively, download from [imagemagick.org](https://imagemagick.org/script/download.php) and add to PATH.)

#### 3. Pandoc (for Document Conversions)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install pandoc
    ```

- **Linux (Fedora):**

    ```bash
    sudo dnf install pandoc
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S pandoc
    ```

- **macOS (using Homebrew):**

    ```bash
    brew install pandoc
    ```

- **Windows (using Chocolatey):**

    ```bash
    choco install pandoc
    ```

    (Alternatively, download from [pandoc.org](https://pandoc.org/installing.html) and add to PATH.)

#### 4. TeX Live (for Advanced Document Conversions, e.g., PDF output from Pandoc)

- **Linux (Debian/Ubuntu):**

    ```bash
    sudo apt update
    sudo apt install texlive-full # Installs a comprehensive TeX Live distribution
    ```

    (For a smaller installation, consider `texlive-latex-extra` and `texlive-fonts-recommended`.)
- **Linux (Fedora):**

    ```bash
    sudo dnf install texlive-scheme-full
    ```

- **Linux (Arch Linux):**

    ```bash
    sudo pacman -S texlive-most
    ```

- **macOS:** Install [MacTeX](https://www.tug.org/mactex/).

- **Windows:** Install [MiKTeX](https://miktex.org/download) or [TeX Live](https://www.tug.org/texlive/acquire-iso.html).

---

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/libre-tools/libreconvert.git
   cd libreconvert
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the application:

   ```bash
   flutter run -d linux  # or -d macos, -d windows depending on your platform
   ```

## Development

libreconvert is built with Flutter, using Dart for core logic. The project structure is as follows:

- **lib/**: Main source code directory.
  - **main.dart**: Entry point for the application.
  - **ui/**: User interface widgets.
  - **utils/**: Utility classes for file handling and conversion.
  - **models/**: Data models for conversion tasks and settings.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request or open an Issue for any bugs, feature requests, or improvements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

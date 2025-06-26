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

- Ensure Flutter is installed and configured for desktop development.
- Install the following tools on your system for full functionality:
  - **ImageMagick**: For image conversions. Install via your package manager (e.g., `sudo apt install imagemagick` on Ubuntu/Debian, or `brew install imagemagick` on macOS with Homebrew).
  - **FFmpeg**: For audio/video conversions. Install via your package manager (e.g., `sudo apt install ffmpeg` on Ubuntu/Debian, or `brew install ffmpeg` on macOS with Homebrew).
  - **Pandoc**: For document conversions. Install via your package manager (e.g., `sudo apt install pandoc` on Ubuntu/Debian, or `brew install pandoc` on macOS with Homebrew).

### Installation

1. Clone the repository (replace `yourusername` with the actual GitHub username or organization):

   ```bash
   git clone https://github.com/yourusername/libreconvert.git
   cd libreconvert
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Run the application:

   ```bash
   flutter run -d windows  # or -d macos, -d linux depending on your platform
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

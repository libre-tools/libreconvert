# OpenConvert: Offline File Converter Application Plan

This document outlines a comprehensive plan to develop "OpenConvert", a powerful, offline-first file converter application using Flutter for desktop platforms. The application will support a wide range of file types, including images, audio, video, and documents, leveraging system-installed FFmpeg and Pandoc for conversions.

## 1. Application Overview

- "OpenConvert" will be a desktop-focused Flutter application designed to convert a wide range of file types (images, audio, video, and documents) offline.
- It will feature a user-friendly GUI for selecting files, choosing output formats, and initiating conversions, with progress indicators, error handling, and advanced configuration options.

## 2. Core Features

- **File Selection**: Allow users to select single or multiple files for conversion using native file dialogs.
- **Format Selection**: Provide dropdowns or selection widgets for choosing target formats based on file type, covering all major formats.
- **Conversion Processing**: Execute conversions locally using system calls to FFmpeg for audio/video, Pandoc for documents, and the 'image' package for image conversions, including support for HEIC.
- **Progress Feedback**: Display conversion progress and results (success or failure) for each file.
- **Configuration Options**: Include settings for specifying paths to FFmpeg and Pandoc binaries if they are not in standard locations.
- **Batch Processing**: Support converting multiple files simultaneously, leveraging Dart's isolates for concurrency.

## 3. Supported Formats

- **Images**: PNG, JPG, BMP, GIF, WebP, HEIC (Apple's High Efficiency Image Container), TIFF, and other major formats supported by the 'image' package or FFmpeg if necessary.
- **Audio & Video**: MP4, MKV, AVI, MOV, WMV, FLV, MP3, WAV, FLAC, OGG, AAC, M4A, and other formats supported by FFmpeg.
- **Documents**: Markdown, HTML, PDF, DOCX, ODT, RTF, TXT, EPUB, and other formats supported by Pandoc.

## 4. Advanced Features

- **Conversion Presets**: Allow users to save and load predefined conversion settings (e.g., "High Quality MP4" or "PDF to DOCX with formatting") for quick reuse.
- **Custom Command Options**: Provide an advanced mode where users can specify custom FFmpeg or Pandoc command parameters for fine-tuned control over conversions (e.g., bitrate, resolution for video, or specific markup options for documents).
- **Format-Specific Settings**: Offer additional options based on file type, such as image compression levels, audio bitrate, or document layout preferences.
- **Conversion Queue Management**: Enable users to prioritize or pause/resume conversions in a queue, especially useful for batch processing large numbers of files.
- **Preview and Validation**: Where feasible, provide previews of converted files (e.g., thumbnails for images/videos) and validate output to ensure successful conversion.
- **Logging and History**: Maintain a history of conversions with detailed logs for troubleshooting or re-running past conversions with the same settings.

## 5. Technology Implementation

- **Flutter GUI**: Use Flutter's widget system to build a responsive interface with Material Design components for consistency across Windows, macOS, and Linux.
- **File Handling**: Utilize Dart's `dart:io` library for reading/writing files and executing system commands to invoke FFmpeg and Pandoc.
- **Image Conversion**: Implement image format conversions, including HEIC, using the 'image' package, with fallback to FFmpeg if needed for unsupported formats.
- **Audio/Video Conversion**: Create a utility class to handle FFmpeg commands, supporting all major formats and ensuring secure command construction to prevent injection vulnerabilities.
- **Document Conversion**: Similarly, create a utility for Pandoc commands, supporting a wide range of document formats.
- **Concurrency**: Use isolates to run conversion tasks in the background, keeping the UI responsive during processing.

## 6. Project Structure

- **lib/**: Main source code directory.
  - **main.dart**: Entry point, setting up the app and desktop configurations.
  - **ui/**: Contains widgets for the user interface (e.g., file selector, format chooser, progress indicators, advanced settings screens).
  - **utils/**: Utility classes for file handling, FFmpeg/Pandoc command execution, image processing, and preset management.
  - **models/**: Data models for representing files, conversion tasks, presets, and settings.
- **assets/**: Store icons, images, or other static resources for the app UI.
- **config/**: Store configuration files or user settings for binary paths and conversion presets.

## 7. Development Steps

- **Step 1: Project Setup**: Ensure Flutter is configured for desktop support (already done for Linux, macOS, and Windows).
- **Step 2: UI Development**: Build the main interface with file selection, format options, conversion controls, and advanced settings using Flutter widgets.
- **Step 3: File Handling**: Implement file selection using packages like 'file_picker' for cross-platform file dialogs.
- **Step 4: Conversion Logic**: Develop modules for image conversion with the 'image' package (including HEIC support), and system calls for FFmpeg and Pandoc, including error handling, path configuration, and custom command support.
- **Step 5: Concurrency and Queue Management**: Integrate Dart isolates to manage multiple conversions and implement a queue system for batch processing with pause/resume capabilities.
- **Step 6: Advanced Features**: Add presets, custom command interfaces, format-specific settings, conversion history, and logging functionalities.
- **Step 7: Testing**: Test the app on different desktop platforms to ensure compatibility, focusing on file conversion accuracy (especially for HEIC and other major formats), UI responsiveness, and advanced feature functionality.
- **Step 8: Packaging**: Prepare the app for distribution, creating executables for Windows, macOS, and Linux under the name "OpenConvert".

## 8. Additional Considerations

- **Security**: Implement input validation to sanitize file paths and command arguments to prevent command injection when calling FFmpeg and Pandoc, especially with custom command options.
- **Error Handling**: Provide clear user feedback for conversion failures, including logs or messages indicating potential issues (e.g., missing binaries, unsupported formats).
- **Performance**: Optimize file processing and system calls to handle large files or batch operations efficiently, with user controls for managing resource usage in advanced settings.

## 9. Future Implementations

- **PDF to Multiple Format Conversion**: Implement support for converting PDFs to various formats including Markdown, text, images, and other document formats using tools like `pdftotext` from the Poppler library for text extraction, `pdf-extract` for content extraction, or `ImageMagick` for conversion to image formats. This will involve checking for the availability of the chosen tool(s) on the user's system, extracting content or converting PDFs as needed, and formatting or saving the output in the desired format. If the necessary tools are not available, provide a fallback message suggesting manual conversion or installation of the required tools.

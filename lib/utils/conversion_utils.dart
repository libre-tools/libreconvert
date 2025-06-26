import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';

final logger = Logger();

class ConversionUtils {
  static Future<bool> convertImage(
    String inputPath,
    String outputPath,
    String format,
  ) async {
    try {
      // Read the image file
      final imageData = await File(inputPath).readAsBytes();
      final image = img.decodeImage(imageData);

      if (image == null) {
        logger.e('Failed to decode image from $inputPath');
        return false;
      }

      // Convert to the target format
      final outputFile = File('$outputPath.${format.toLowerCase()}');
      final outputData = _encodeImage(image, format.toLowerCase());

      if (outputData == null) {
        logger.e(
          'Unsupported format: $format. Conversion for this format is not currently supported by the image library.',
        );
        return false;
      }

      await outputFile.writeAsBytes(outputData);
      logger.i(
        'Image converted successfully to $outputPath.${format.toLowerCase()}',
      );
      return true;
    } catch (e) {
      logger.e('Error converting image: $e');
      return false;
    }
  }

  static List<int>? _encodeImage(img.Image image, String format) {
    switch (format) {
      case 'png':
        return img.encodePng(image);
      case 'jpg':
      case 'jpeg':
        return img.encodeJpg(image, quality: 85);
      case 'bmp':
        return img.encodeBmp(image);
      case 'gif':
        return img.encodeGif(image);
      case 'webp':
        // TODO: WebP encoding is not directly supported in current 'image' package version.
        // Consider fallback to FFmpeg or another library for WebP support.
        return null;
      default:
        return null;
    }
  }

  static Future<bool> convertAudioVideo(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    try {
      // Check if FFmpeg is available
      bool ffmpegAvailable = await checkBinaryAvailability('ffmpeg');
      if (!ffmpegAvailable) {
        logger.e(
          'Error: FFmpeg is not installed or not found in PATH. Please install FFmpeg to convert audio/video files.',
        );
        return false;
      }

      // Construct FFmpeg command with basic parameters
      List<String> arguments = [
        '-i',
        inputPath,
        '-y',
      ]; // -y to overwrite output if exists

      // Add custom options if provided
      if (customOptions != null) {
        customOptions.forEach((key, value) {
          arguments.add(key);
          if (value.isNotEmpty) {
            arguments.add(value);
          }
        });
      }

      // Add output path with format extension
      arguments.add('$outputPath.${format.toLowerCase()}');

      // Execute FFmpeg command
      final result = await Process.run('ffmpeg', arguments);
      if (result.exitCode == 0) {
        logger.i(
          'Audio/Video converted successfully to $outputPath.${format.toLowerCase()}',
        );
        return true;
      } else {
        logger.e('FFmpeg error: ${result.stderr}');
        return false;
      }
    } catch (e) {
      logger.e('Error converting audio/video: $e');
      return false;
    }
  }

  static Future<bool> convertDocument(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    try {
      // Check if Pandoc is available
      bool pandocAvailable = await checkBinaryAvailability('pandoc');
      if (!pandocAvailable) {
        logger.e(
          'Error: Pandoc is not installed or not found in PATH. Please install Pandoc to convert document files.',
        );
        return false;
      }

      // Check if input is PDF, which Pandoc cannot convert from
      final inputFormat = inputPath.split('.').last.toLowerCase();
      if (inputFormat == 'pdf') {
        logger.e(
          'Error: Pandoc cannot convert from PDF format. For PDF conversion, consider using tools like ImageMagick (for PDF to image) or pdf-extract (for text extraction). Currently, this functionality is not implemented in OpenConvert. As a workaround, you can manually convert the PDF to another format using an external tool and then use OpenConvert for further conversions.',
        );
        return false;
      }

      // Construct Pandoc command with basic parameters
      List<String> arguments = [
        inputPath,
        '-o',
        '$outputPath.${format.toLowerCase()}',
      ];

      // Add custom options if provided
      if (customOptions != null) {
        customOptions.forEach((key, value) {
          arguments.add('$key=$value');
        });
      }

      // Execute Pandoc command
      final result = await Process.run('pandoc', arguments);
      if (result.exitCode == 0) {
        logger.i(
          'Document converted successfully to $outputPath.${format.toLowerCase()}',
        );
        return true;
      } else {
        logger.e('Pandoc error: ${result.stderr}');
        if (result.stderr.contains('Font') ||
            result.stderr.contains('mktextfm') ||
            result.stderr.contains('TeX')) {
          logger.e(
            'This error likely indicates missing LaTeX dependencies. Please install a LaTeX distribution like TeX Live (e.g., `sudo apt install texlive-full` on Debian/Ubuntu) to enable PDF and other document format conversions.',
          );
        }
        return false;
      }
    } catch (e) {
      logger.e('Error converting document: $e');
      return false;
    }
  }

  static Future<bool> checkBinaryAvailability(String binaryName) async {
    try {
      final result = await Process.run('which', [binaryName]);
      if (result.exitCode == 0 && result.stdout.isNotEmpty) {
        logger.i('$binaryName is available at: ${result.stdout.trim()}');
        return true;
      } else {
        logger.w('$binaryName is not found in PATH.');
        return false;
      }
    } catch (e) {
      logger.e('Error checking $binaryName availability: $e');
      // Fallback to direct version check if 'which' is not available
      try {
        final versionResult = await Process.run(binaryName, ['--version']);
        if (versionResult.exitCode == 0) {
          logger.i('$binaryName is available: ${versionResult.stdout}');
          return true;
        } else {
          logger.w('$binaryName is not available: ${versionResult.stderr}');
          return false;
        }
      } catch (e2) {
        logger.e('Fallback error checking $binaryName availability: $e2');
        return false;
      }
    }
  }
}

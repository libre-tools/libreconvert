import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

final logger = Logger();

// Top-level function for image conversion to be run in an isolate
Future<Map<String, dynamic>> _convertImageIsolate(
  Map<String, String> params,
) async {
  final inputPath = params['inputPath']!;
  final outputPath = params['outputPath']!;
  final format = params['format']!;
  Map<String, dynamic> result = await ConversionUtils.convertImageWithPath(
    inputPath,
    outputPath,
    format,
  );
  return result;
}

// Top-level function for audio/video conversion to be run in an isolate
Future<Map<String, dynamic>> _convertAudioVideoIsolate(
  Map<String, dynamic> params,
) async {
  final inputPath = params['inputPath'] as String;
  final outputPath = params['outputPath'] as String;
  final format = params['format'] as String;
  final customOptions = params['customOptions'] as Map<String, String>?;
  Map<String, dynamic> result = await ConversionUtils.convertAudioVideoWithPath(
    inputPath,
    outputPath,
    format,
    customOptions: customOptions,
  );
  return result;
}

// Top-level function for document conversion to be run in an isolate
Future<Map<String, dynamic>> _convertDocumentIsolate(
  Map<String, dynamic> params,
) async {
  final inputPath = params['inputPath'] as String;
  final outputPath = params['outputPath'] as String;
  final format = params['format'] as String;
  final customOptions = params['customOptions'] as Map<String, String>?;
  Map<String, dynamic> result = await ConversionUtils.convertDocumentWithPath(
    inputPath,
    outputPath,
    format,
    customOptions: customOptions,
  );
  return result;
}

class ConversionUtils {
  static Future<Map<String, dynamic>> convertImageWithIsolate(
    String inputPath,
    String outputPath,
    String format,
  ) async {
    // Avoid using Isolate.run to prevent BackgroundIsolateBinaryMessenger error
    return await _convertImageIsolate({
      'inputPath': inputPath,
      'outputPath': outputPath,
      'format': format,
    });
  }

  static Future<Map<String, dynamic>> convertAudioVideoWithIsolate(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    // Avoid using Isolate.run to prevent BackgroundIsolateBinaryMessenger error
    return await _convertAudioVideoIsolate({
      'inputPath': inputPath,
      'outputPath': outputPath,
      'format': format,
      'customOptions': customOptions,
    });
  }

  static Future<Map<String, dynamic>> convertDocumentWithIsolate(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    // Avoid using Isolate.run to prevent BackgroundIsolateBinaryMessenger error
    return await _convertDocumentIsolate({
      'inputPath': inputPath,
      'outputPath': outputPath,
      'format': format,
      'customOptions': customOptions,
    });
  }

  static Future<Map<String, dynamic>> convertImageWithPath(
    String inputPath,
    String outputPath,
    String format,
  ) async {
    try {
      // Check if ImageMagick is available
      bool imagemagickAvailable = await checkBinaryAvailability('convert');
      if (!imagemagickAvailable) {
        logger.e(
          'ImageMagick is not installed or not found in PATH. Please install ImageMagick for image conversions.',
        );
        return {'success': false, 'tempOutputPath': ''};
      }

      // Use a temporary directory for storing converted files
      final tempDir = await getTemporaryDirectory();
      final tempOutputPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_converted.${format.toLowerCase()}';

      // Construct ImageMagick convert command
      List<String> arguments = [inputPath, tempOutputPath];

      // Execute ImageMagick convert command
      final result = await Process.run('convert', arguments);
      if (result.exitCode == 0) {
        logger.i(
          'Image converted successfully to $tempOutputPath using ImageMagick',
        );
        return {'success': true, 'tempOutputPath': tempOutputPath};
      } else {
        logger.e('ImageMagick error: ${result.stderr}');
        return {'success': false, 'tempOutputPath': ''};
      }
    } catch (e) {
      logger.e('Error converting image with ImageMagick: $e');
      return {'success': false, 'tempOutputPath': ''};
    }
  }

  static Future<bool> convertImage(
    String inputPath,
    String outputPath,
    String format,
  ) async {
    Map<String, dynamic> result = await convertImageWithPath(
      inputPath,
      outputPath,
      format,
    );
    return result['success'] as bool;
  }

  static Future<Map<String, dynamic>> convertAudioVideoWithPath(
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
        return {'success': false, 'tempOutputPath': ''};
      }

      // Use a temporary directory for storing converted files
      final tempDir = await getTemporaryDirectory();
      final tempOutputPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_converted.${format.toLowerCase()}';

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
      arguments.add(tempOutputPath);

      // Execute FFmpeg command
      final result = await Process.run('ffmpeg', arguments);
      if (result.exitCode == 0) {
        logger.i('Audio/Video converted successfully to $tempOutputPath');
        return {'success': true, 'tempOutputPath': tempOutputPath};
      } else {
        logger.e('FFmpeg error: ${result.stderr}');
        return {'success': false, 'tempOutputPath': ''};
      }
    } catch (e) {
      logger.e('Error converting audio/video: $e');
      return {'success': false, 'tempOutputPath': ''};
    }
  }

  static Future<bool> convertAudioVideo(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    Map<String, dynamic> result = await convertAudioVideoWithPath(
      inputPath,
      outputPath,
      format,
      customOptions: customOptions,
    );
    return result['success'] as bool;
  }

  static Future<Map<String, dynamic>> convertDocumentWithPath(
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
        return {'success': false, 'tempOutputPath': ''};
      }

      // Check if input is PDF, which Pandoc cannot convert from
      final inputFormat = inputPath.split('.').last.toLowerCase();
      if (inputFormat == 'pdf') {
        logger.e(
          'Error: Pandoc cannot convert from PDF format. For PDF conversion, consider using tools like ImageMagick (for PDF to image) or pdf-extract (for text extraction). Currently, this functionality is not implemented in OpenConvert. As a workaround, you can manually convert the PDF to another format using an external tool and then use OpenConvert for further conversions.',
        );
        return {'success': false, 'tempOutputPath': ''};
      }

      // Use a temporary directory for storing converted files
      final tempDir = await getTemporaryDirectory();
      final tempOutputPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_converted.${format.toLowerCase()}';

      // Construct Pandoc command with basic parameters
      List<String> arguments = [inputPath, '-o', tempOutputPath];

      // Add custom options if provided
      if (customOptions != null) {
        customOptions.forEach((key, value) {
          arguments.add('$key=$value');
        });
      }

      // Execute Pandoc command
      final result = await Process.run('pandoc', arguments);
      if (result.exitCode == 0) {
        logger.i('Document converted successfully to $tempOutputPath');
        return {'success': true, 'tempOutputPath': tempOutputPath};
      } else {
        logger.e('Pandoc error: ${result.stderr}');
        if (result.stderr.contains('Font') ||
            result.stderr.contains('mktextfm') ||
            result.stderr.contains('TeX')) {
          logger.e(
            'This error likely indicates missing LaTeX dependencies. Please install a LaTeX distribution like TeX Live (e.g., `sudo apt install texlive-full` on Debian/Ubuntu) to enable PDF and other document format conversions.',
          );
        }
        return {'success': false, 'tempOutputPath': ''};
      }
    } catch (e) {
      logger.e('Error converting document: $e');
      return {'success': false, 'tempOutputPath': ''};
    }
  }

  static Future<bool> convertDocument(
    String inputPath,
    String outputPath,
    String format, {
    Map<String, String>? customOptions,
  }) async {
    Map<String, dynamic> result = await convertDocumentWithPath(
      inputPath,
      outputPath,
      format,
      customOptions: customOptions,
    );
    return result['success'] as bool;
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

  static Future<String?> generateVideoThumbnail(String videoPath) async {
    try {
      // Check if FFmpeg is available
      bool ffmpegAvailable = await checkBinaryAvailability('ffmpeg');
      if (!ffmpegAvailable) {
        logger.e(
          'Error: FFmpeg is not installed or not found in PATH. Please install FFmpeg to generate video thumbnails.',
        );
        return null;
      }

      // Generate a temporary file path for the thumbnail
      final tempDir = await getTemporaryDirectory();
      final outputPath =
          '${tempDir.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.png';

      // Construct FFmpeg command to extract a thumbnail
      List<String> arguments = [
        '-i',
        videoPath,
        '-ss',
        '00:00:01', // Seek to 1 second
        '-vframes',
        '1', // Extract 1 frame
        outputPath,
      ];

      // Execute FFmpeg command
      final result = await Process.run('ffmpeg', arguments);
      if (result.exitCode == 0) {
        logger.i('Video thumbnail generated successfully at $outputPath');
        return outputPath;
      } else {
        logger.e('FFmpeg error: ${result.stderr}');
        return null;
      }
    } catch (e) {
      logger.e('Error generating video thumbnail: $e');
      return null;
    }
  }
}

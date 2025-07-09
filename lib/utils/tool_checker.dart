import 'dart:io';
import 'package:logger/logger.dart'; // Added logger import

final logger = Logger(); // Initialize logger

class ToolChecker {
  static Future<bool> isToolInstalled(String toolName) async {
    try {
      ProcessResult result;
      if (Platform.isWindows) {
        result = await Process.run('where', [toolName]);
      } else {
        result = await Process.run('which', [toolName]);
      }
      return result.exitCode == 0;
    } catch (e) {
      logger.e('Error checking tool $toolName: $e');
      return false;
    }
  }

  static Future<Map<String, bool>> checkAllTools() async {
    final Map<String, List<String>> toolExecutables = {
      'ffmpeg': ['ffmpeg'],
      'imagemagick': ['magick', 'convert'], // Check for both common ImageMagick executables
      'pandoc': ['pandoc'],
      'texlive': ['pdflatex', 'xelatex'], // Check for common TeX Live executables
      'potrace': ['potrace'], // Check for potrace for SVG conversions
    };

    final Map<String, bool> installedTools = {};

    for (var entry in toolExecutables.entries) {
      final toolName = entry.key;
      final executables = entry.value;
      bool found = false;
      for (var executable in executables) {
        if (await isToolInstalled(executable)) {
          found = true;
          break;
        }
      }
      installedTools[toolName] = found;
    }
    return installedTools;
  }
}
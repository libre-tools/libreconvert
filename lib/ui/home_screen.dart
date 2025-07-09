import 'package:libreconvert/ui/file_selector.dart';
import 'package:libreconvert/ui/format_selector.dart';
import 'package:libreconvert/ui/common/header_widget.dart';
import 'package:libreconvert/models/conversion_task.dart';
import 'package:libreconvert/utils/conversion_utils.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

final logger = Logger();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedFiles = [];
  String? selectedFormat;
  String currentFileType = 'image';
  String currentCategory = 'Image';
  List<ConversionTask> conversionTasks = [];
  bool isConverting = false;

  void _updateSelectedFormat(String? format) {
    setState(() {
      selectedFormat = format;
    });
  }

  void _updateSelectedFiles(List<String> files, List<String> extensions) {
    setState(() {
      selectedFiles = files;
      if (extensions.isNotEmpty) {
        String ext = extensions[0].toLowerCase();
        if (['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].contains(ext)) {
          currentFileType = 'image';
          currentCategory = 'Image';
        } else if (['mp3', 'wav', 'flac', 'ogg'].contains(ext)) {
          currentFileType = 'audio';
          currentCategory = 'Audio';
        } else if (['mp4', 'mkv', 'avi', 'mov'].contains(ext)) {
          currentFileType = 'video';
          currentCategory = 'Video';
        } else if (['md', 'html', 'pdf', 'docx', 'odt', 'txt'].contains(ext)) {
          currentFileType = 'document';
          currentCategory = 'Document';
        }
      } else {
        // Reset app state when files are cleared
        selectedFormat = null;
        conversionTasks = [];
        isConverting = false;
      }
    });
  }

  Future<void> _startConversion(List<String> filePaths) async {
    if (isConverting || selectedFormat == null) return;

    setState(() {
      isConverting = true;
      conversionTasks = filePaths.map((path) {
        return ConversionTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          filePath: path,
          fileType: currentFileType,
          targetFormat: selectedFormat!,
        );
      }).toList();
    });

    for (var task in conversionTasks) {
      setState(() {
        conversionTasks = conversionTasks.map((t) {
          if (t.id == task.id) {
            return ConversionTask(
              id: t.id,
              filePath: t.filePath,
              fileType: t.fileType,
              targetFormat: t.targetFormat,
              status: 'Processing',
              progress: 0.0,
            );
          }
          return t;
        }).toList();
      });

      Map<String, dynamic> result;
      final tempDir = await getTemporaryDirectory();
      final baseOutputPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}_converted';
      if (task.fileType == 'image') {
        result = await ConversionUtils.convertImageWithIsolate(
          task.filePath,
          baseOutputPath,
          task.targetFormat,
        );
      } else if (task.fileType == 'audio' || task.fileType == 'video') {
        result = await ConversionUtils.convertAudioVideoWithIsolate(
          task.filePath,
          baseOutputPath,
          task.targetFormat,
        );
      } else {
        result = await ConversionUtils.convertDocumentWithIsolate(
          task.filePath,
          baseOutputPath,
          task.targetFormat,
        );
      }

      bool success = result['success'] as bool;
      String tempOutputPath = success ? result['tempOutputPath'] as String : '';

      setState(() {
        conversionTasks = conversionTasks.map((t) {
          if (t.id == task.id) {
            return ConversionTask(
              id: t.id,
              filePath: t.filePath,
              fileType: t.fileType,
              targetFormat: t.targetFormat,
              status: success ? 'Completed' : 'Failed',
              progress: success ? 1.0 : 0.0,
              outputPath: success ? tempOutputPath : null,
              errorMessage: success ? null : 'Conversion failed',
            );
          }
          return t;
        }).toList();
      });
    }

    setState(() {
      isConverting = false;
    });
  }

  Future<void> _saveAllConvertedFiles() async {
    final completedTasks = conversionTasks
        .where((task) => task.status == 'Completed' && task.outputPath != null)
        .toList();

    if (completedTasks.isEmpty) {
      if (mounted) {
        showToast(
          context: context,
          builder: (context, overlay) {
            return SurfaceCard(
              child: Basic(
                title: const Text('No Files to Save'),
                subtitle: const Text(
                  'There are no completed conversions to save.',
                ),
                trailing: PrimaryButton(
                  size: ButtonSize.small,
                  onPressed: () {
                    overlay.close();
                  },
                  child: const Text('Dismiss'),
                ),
                trailingAlignment: Alignment.center,
              ),
            );
          },
          location: ToastLocation.bottomCenter,
        );
      }
      return;
    }

    for (var task in completedTasks) {
      final fileName =
          '${task.filePath.split('/').last.split('.').first}_converted.${task.targetFormat.toLowerCase() == "markdown" ? "md" : task.targetFormat.toLowerCase()}';
      String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save $fileName',
        fileName: fileName,
      );

      if (outputFile != null) {
        try {
          final sourceFile = File(task.outputPath!);
          if (await sourceFile.exists()) {
            await sourceFile.copy(outputFile);
            if (mounted) {
              showToast(
                context: context,
                builder: (context, overlay) {
                  return SurfaceCard(
                    child: Basic(
                      title: const Text('File Saved'),
                      subtitle: Text('File saved to $outputFile'),
                      trailing: PrimaryButton(
                        size: ButtonSize.small,
                        onPressed: () {
                          final directoryPath = outputFile.substring(
                            0,
                            outputFile.lastIndexOf('/'),
                          );
                          Process.run('xdg-open', [directoryPath]).catchError((
                            e,
                          ) {
                            logger.e('Error opening folder: $e');
                            return ProcessResult(
                              0,
                              1,
                              '',
                              'Error opening folder: $e',
                            );
                          });
                          overlay.close();
                        },
                        child: const Text('Open'),
                      ),
                      trailingAlignment: Alignment.center,
                    ),
                  );
                },
                location: ToastLocation.topRight,
              );
            }
          } else {
            logger.e('Temporary file does not exist: ${task.outputPath}');
            if (mounted) {
              showToast(
                context: context,
                builder: (context, overlay) {
                  return SurfaceCard(
                    child: Basic(
                      title: const Text('Error Saving File'),
                      subtitle: const Text(
                        'The temporary converted file could not be found. It may have been deleted or moved.',
                      ),
                      trailing: PrimaryButton(
                        size: ButtonSize.small,
                        onPressed: () {
                          overlay.close();
                        },
                        child: const Text('Dismiss'),
                      ),
                      trailingAlignment: Alignment.center,
                    ),
                  );
                },
                location: ToastLocation.topRight,
              );
            }
          }
        } catch (e) {
          logger.e(
            'Error saving file from ${task.outputPath} to $outputFile: $e',
          );
          if (mounted) {
            showToast(
              context: context,
              builder: (context, overlay) {
                return SurfaceCard(
                  child: Basic(
                    title: const Text('Error Saving File'),
                    subtitle: Text(
                      'An error occurred while saving the file: $e',
                    ),
                    trailing: PrimaryButton(
                      size: ButtonSize.small,
                      onPressed: () {
                        overlay.close();
                      },
                      child: const Text('Dismiss'),
                    ),
                    trailingAlignment: Alignment.center,
                  ),
                );
              },
              location: ToastLocation.topRight,
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasCompletedTasks = conversionTasks.any(
      (task) => task.status == 'Completed',
    );
    final hasSelectedFiles = selectedFiles.isNotEmpty;

    return Material(
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(24.0),
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeaderWidget(
                title: 'Welcome to LibreConvert',
                subtitle: 'Select files to convert with ease.',
                actions: [
                  if (selectedFiles.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 180,
                          child: FormatSelector(
                            fileType: currentFileType,
                            sourceExtension: selectedFiles.isNotEmpty
                                ? selectedFiles[0]
                                    .split('.')
                                    .last
                                    .toLowerCase()
                                : null,
                            onFormatSelected: _updateSelectedFormat,
                          ),
                        ),
                        const SizedBox(width: 12),
                        PrimaryButton(
                          onPressed: isConverting ||
                                  selectedFormat == null ||
                                  selectedFiles.isEmpty
                              ? null
                              : () {
                                  _startConversion(selectedFiles);
                                },
                          child: const Text('Convert'),
                        ),
                        if (hasCompletedTasks && hasSelectedFiles) ...[
                          const SizedBox(width: 12),
                          PrimaryButton(
                            onPressed: _saveAllConvertedFiles,
                            child: const Text('Save'),
                          ),
                        ]
                      ],
                    )
                ],
              ),
              gap(15),
              Expanded(
                child: FileSelector(
                  onFilesSelected: _updateSelectedFiles,
                  conversionTasks: conversionTasks,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

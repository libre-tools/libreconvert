import 'package:libreconvert/ui/file_selector.dart';
import 'package:libreconvert/ui/format_selector.dart';
import 'package:libreconvert/ui/common/header_widget.dart';
import 'package:libreconvert/models/conversion_task.dart';
import 'package:libreconvert/utils/conversion_utils.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

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

      bool success = false;
      String outputPath = '${task.filePath.split('.').first}_converted';
      if (task.fileType == 'image') {
        success = await ConversionUtils.convertImage(
          task.filePath,
          outputPath,
          task.targetFormat,
        );
      } else if (task.fileType == 'audio' || task.fileType == 'video') {
        success = await ConversionUtils.convertAudioVideo(
          task.filePath,
          outputPath,
          task.targetFormat,
        );
      } else {
        success = await ConversionUtils.convertDocument(
          task.filePath,
          outputPath,
          task.targetFormat,
        );
      }

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
              outputPath: success
                  ? '$outputPath.${task.targetFormat.toLowerCase()}'
                  : null,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: const EdgeInsets.all(24.0),
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - 48.0,
          ),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HeaderWidget(
                    title: 'Welcome to libreconvert',
                    subtitle: 'Select files to convert with ease.',
                    actions: [
                      if (selectedFiles.isNotEmpty)
                        Container(
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: FormatSelector(
                              fileType: currentFileType,
                              onFormatSelected: _updateSelectedFormat,
                            ),
                          ),
                        ),
                      if (selectedFiles.isNotEmpty)
                        PrimaryButton(
                          onPressed:
                              isConverting ||
                                  selectedFormat == null ||
                                  selectedFiles.isEmpty
                              ? null
                              : () {
                                  _startConversion(selectedFiles);
                                },

                          child: const Text('Convert'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  FileSelector(
                    onFilesSelected: _updateSelectedFiles,
                    conversionTasks: conversionTasks,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

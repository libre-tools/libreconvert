import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:dotted_border/dotted_border.dart';

import 'package:libreconvert/models/conversion_task.dart';

class FileSelector extends StatefulWidget {
  final Function(List<String>, List<String>) onFilesSelected;
  final List<ConversionTask> conversionTasks;

  const FileSelector({
    super.key,
    required this.onFilesSelected,
    this.conversionTasks = const [],
  });

  @override
  State<FileSelector> createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  List<String> selectedFiles = [];
  String? currentFileExtension;

  @override
  void didUpdateWidget(covariant FileSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    // No automatic clearing of selected files
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        // Images
        'png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp',
        // Audio
        'mp3', 'wav', 'flac', 'ogg', 'aac', 'm4a',
        // Video
        'mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv',
        // Documents (excluding PDF)
        'docx', 'odt', 'rtf', 'txt', 'html', 'md', 'epub',
      ],
    );

    if (result != null) {
      final paths = result.paths
          .where((path) => path != null)
          .cast<String>()
          .toList();
      final extensions = paths
          .map((path) => path.split('.').last.toLowerCase())
          .toList();
      final pdfPaths = paths
          .where((path) => path.toLowerCase().endsWith('.pdf'))
          .toList();
      if (pdfPaths.isNotEmpty) {
        if (mounted) {
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  title: const Text('PDF Not Supported'),
                  subtitle: const Text('PDF conversion is not supported yet.'),
                  trailing: PrimaryButton(
                    size: ButtonSize.small,
                    onPressed: () {
                      overlay.close();
                    },
                    child: const Text('OK'),
                  ),
                  trailingAlignment: Alignment.center,
                ),
              );
            },
            location: ToastLocation.bottomRight,
          );
        }
      } else if (_checkFileExtensionConsistency(extensions)) {
        setState(() {
          selectedFiles.addAll(paths);
          widget.onFilesSelected(selectedFiles, extensions);
        });
      } else {
        if (mounted) {
          showToast(
            context: context,
            builder: (context, overlay) {
              return SurfaceCard(
                child: Basic(
                  title: const Text('Invalid Selection'),
                  subtitle: const Text(
                    'Mixed file formats are not allowed. Please select files with the same format (e.g., only .txt or only .md).',
                  ),
                  trailing: PrimaryButton(
                    size: ButtonSize.small,
                    onPressed: () {
                      overlay.close();
                    },
                    child: const Text('OK'),
                  ),
                  trailingAlignment: Alignment.center,
                ),
              );
            },
            location: ToastLocation.bottomRight,
          );
        }
      }
    }
  }

  void _removeFile(int index) {
    setState(() {
      selectedFiles.removeAt(index);
      final extensions = selectedFiles
          .map((path) => path.split('.').last.toLowerCase())
          .toList();
      widget.onFilesSelected(selectedFiles, extensions);
      if (selectedFiles.isEmpty) {
        currentFileExtension = null;
      }
    });
  }

  bool _checkFileExtensionConsistency(List<String> extensions) {
    if (extensions.isEmpty) return true;
    if (currentFileExtension == null && selectedFiles.isEmpty) {
      currentFileExtension = extensions[0];
    }
    final expectedExtension = currentFileExtension ?? extensions[0];
    for (final ext in extensions) {
      if (ext != expectedExtension) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedFiles.isEmpty)
          DropTarget(
            onDragDone: (detail) {
              final paths = detail.files.map((file) => file.path).toList();
              final extensions = paths
                  .map((path) => path.split('.').last.toLowerCase())
                  .toList();
              final pdfPaths = paths
                  .where((path) => path.toLowerCase().endsWith('.pdf'))
                  .toList();
              if (pdfPaths.isNotEmpty) {
                if (mounted) {
                  showToast(
                    context: context,
                    builder: (context, overlay) {
                      return SurfaceCard(
                        child: Basic(
                          title: const Text('PDF Not Supported'),
                          subtitle: const Text(
                            'PDF conversion is not supported yet.',
                          ),
                          trailing: PrimaryButton(
                            size: ButtonSize.small,
                            onPressed: () {
                              overlay.close();
                            },
                            child: const Text('OK'),
                          ),
                          trailingAlignment: Alignment.center,
                        ),
                      );
                    },
                    location: ToastLocation.bottomRight,
                  );
                }
              } else if (_checkFileExtensionConsistency(extensions)) {
                setState(() {
                  selectedFiles = paths;
                  widget.onFilesSelected(selectedFiles, extensions);
                });
              } else {
                if (mounted) {
                  showToast(
                    context: context,
                    builder: (context, overlay) {
                      return SurfaceCard(
                        child: Basic(
                          title: const Text('Invalid Drop'),
                          subtitle: const Text(
                            'Mixed file formats are not allowed. Please drop files with the same format (e.g., only .txt or only .md).',
                          ),
                          trailing: PrimaryButton(
                            size: ButtonSize.small,
                            onPressed: () {
                              overlay.close();
                            },
                            child: const Text('OK'),
                          ),
                          trailingAlignment: Alignment.center,
                        ),
                      );
                    },
                    location: ToastLocation.bottomRight,
                  );
                }
              }
            },
            child: GestureDetector(
              onTap: _pickFiles,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    color: Theme.of(context).colorScheme.accentForeground,
                    dashPattern: [10, 5],
                    strokeWidth: 2,
                    radius: const Radius.circular(8),

                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload_outlined, size: 40),
                            gap(10),
                            Text(
                              "Drag and drop files here, or click to select files",
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        else
          DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: Theme.of(context).colorScheme.accentForeground,
              dashPattern: [10, 5],
              strokeWidth: 2,
              radius: const Radius.circular(8),
              padding: EdgeInsets.symmetric(horizontal: 8),
            ),
            child: SizedBox(
              height: 300,
              width: double.infinity,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 120,
                ),
                itemCount: selectedFiles.length,
                itemBuilder: (context, index) {
                  final filePath = selectedFiles[index];
                  final fileName = filePath.split('/').last;
                  final extension = fileName.split('.').last.toLowerCase();
                  IconData previewIcon;
                  if ([
                    'png',
                    'jpg',
                    'jpeg',
                    'gif',
                    'bmp',
                    'webp',
                  ].contains(extension)) {
                    previewIcon = Icons.image;
                  } else if ([
                    'mp3',
                    'wav',
                    'flac',
                    'ogg',
                    'aac',
                    'm4a',
                  ].contains(extension)) {
                    previewIcon = Icons.audiotrack;
                  } else if ([
                    'mp4',
                    'mkv',
                    'avi',
                    'mov',
                    'wmv',
                    'flv',
                    'gif',
                  ].contains(extension)) {
                    previewIcon = Icons.videocam;
                  } else if ([
                    'pdf',
                    'docx',
                    'odt',
                    'rtf',
                    'txt',
                    'html',
                    'markdown',
                    'epub',
                  ].contains(extension)) {
                    previewIcon = Icons.description;
                  } else {
                    previewIcon = Icons.insert_drive_file;
                  }
                  // Check if this file is in the conversion tasks
                  final task = widget.conversionTasks.firstWhere(
                    (t) => t.filePath == filePath,
                    orElse: () => ConversionTask(
                      id: '',
                      filePath: '',
                      fileType: '',
                      targetFormat: '',
                    ),
                  );

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 80,
                            child: Stack(
                              children: [
                                Center(
                                  child: Icon(
                                    previewIcon,
                                    size: 70,
                                    color: Colors.gray,
                                  ),
                                ),
                                if (task.filePath.isNotEmpty)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.5,
                                        ),
                                        child: Center(
                                          child: task.status == 'Completed'
                                              ? const Icon(
                                                  Icons.check_circle_outline,
                                                  color: Colors.green,
                                                  size: 32,
                                                )
                                              : task.status == 'Failed'
                                              ? const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 32,
                                                )
                                              : const CircularProgressIndicator(),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          IconButton.text(
                            icon: const Icon(
                              Icons.remove_circle,
                              color: Color.fromRGBO(239, 68, 68, 1),
                            ),
                            onPressed: () => _removeFile(index),
                          ),
                        ],
                      ),
                      Text(
                        fileName,
                        style: const TextStyle(
                          color: Color.fromRGBO(17, 24, 39, 1),
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        softWrap: true,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        Visibility(
          visible: selectedFiles.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${selectedFiles.length} file(s) selected.',
                  style: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 1),
                    fontSize: 14,
                  ),
                ),
                DestructiveButton(
                  enabled: true,
                  onPressed: () async {
                    setState(() {
                      selectedFiles.clear();
                      currentFileExtension = null;
                      widget.onFilesSelected([], []);
                    });
                    // Reset app state by notifying parent to clear conversion tasks
                    // This can be achieved by passing a callback or using a state management solution
                    // For now, we'll assume the parent listens to empty file selection to reset state
                  },
                  child: const Text('Reset'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

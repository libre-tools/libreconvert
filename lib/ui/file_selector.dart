import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';
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
  String? currentFileCategory;

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
        // Documents
        'pdf', 'docx', 'odt', 'rtf', 'txt', 'html', 'md', 'epub',
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
      if (_checkFileCategoryConsistency(extensions)) {
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
                    'Mixed file categories are not allowed. Please select files from the same category (e.g., only images, only videos).',
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
        currentFileCategory = null;
      }
    });
  }

  bool _checkFileCategoryConsistency(List<String> extensions) {
    if (extensions.isEmpty) return true;
    if (currentFileCategory == null && selectedFiles.isEmpty) {
      currentFileCategory = _getFileCategory(extensions[0]);
    }
    final expectedCategory =
        currentFileCategory ?? _getFileCategory(extensions[0]);
    for (final ext in extensions) {
      final category = _getFileCategory(ext);
      if (category != expectedCategory) {
        return false;
      }
    }
    return true;
  }

  String _getFileCategory(String extension) {
    if (['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].contains(extension)) {
      return 'image';
    } else if ([
      'mp3',
      'wav',
      'flac',
      'ogg',
      'aac',
      'm4a',
    ].contains(extension)) {
      return 'audio';
    } else if (['mp4', 'mkv', 'avi', 'mov', 'wmv', 'flv'].contains(extension)) {
      return 'video';
    } else if ([
      'pdf',
      'docx',
      'odt',
      'rtf',
      'txt',
      'html',
      'md',
      'epub',
    ].contains(extension)) {
      return 'document';
    }
    return 'other';
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
              if (_checkFileCategoryConsistency(extensions)) {
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
                            'Mixed file categories are not allowed. Please drop files from the same category (e.g., only images, only videos).',
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
                    location: ToastLocation.bottomLeft,
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
                    dashPattern: [10, 5],
                    strokeWidth: 2,
                    radius: const Radius.circular(8),

                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 40),
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
              dashPattern: [10, 5],
              strokeWidth: 2,
              radius: const Radius.circular(8),
              padding: EdgeInsets.symmetric(vertical: 8),
            ),
            child: SizedBox(
              height: 250,
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
                                  child: FutureBuilder<Widget>(
                                    future: _getFilePreview(
                                      filePath,
                                      extension,
                                      previewIcon,
                                    ),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator();
                                      }
                                      if (snapshot.hasData) {
                                        return snapshot.data!;
                                      }
                                      return Icon(
                                        previewIcon,
                                        size: 50,
                                        color: const Color.fromRGBO(
                                          107,
                                          114,
                                          128,
                                          1,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (task.filePath.isNotEmpty)
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        color: Colors.black.withValues(
                                          alpha: 0.3,
                                        ),
                                        child: Center(
                                          child: task.status == 'Completed'
                                              ? const Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                  size: 40,
                                                )
                                              : task.status == 'Failed'
                                              ? const Icon(
                                                  Icons.error,
                                                  color: Colors.red,
                                                  size: 40,
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
                      const SizedBox(height: 4),
                      Text(
                        fileName,
                        style: const TextStyle(
                          color: Color.fromRGBO(17, 24, 39, 1),
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
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
                  onPressed: () {
                    setState(() {
                      selectedFiles.clear();
                      currentFileCategory = null;
                      widget.onFilesSelected([], []);
                    });
                  },
                  child: const Text('Clear all'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<Widget> _getFilePreview(
    String filePath,
    String extension,
    IconData defaultIcon,
  ) async {
    try {
      if (['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp'].contains(extension)) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(filePath),
            fit: BoxFit.cover,
            width: 80,
            height: 80,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.image,
                size: 50,
                color: const Color.fromRGBO(107, 114, 128, 1),
              );
            },
          ),
        );
      } else if ([
        'mp4',
        'mkv',
        'avi',
        'mov',
        'wmv',
        'flv',
      ].contains(extension)) {
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: filePath,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.PNG,
          maxHeight: 100,
          maxWidth: 100,
          quality: 100,
        );
        if (thumbnailPath != null) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(thumbnailPath),
              fit: BoxFit.cover,
              width: 80,
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.videocam,
                  size: 50,
                  color: const Color.fromRGBO(107, 114, 128, 1),
                );
              },
            ),
          );
        }
      } else if (extension == 'pdf') {
        final doc = await PdfDocument.openFile(filePath);
        if (doc.pageCount > 0) {
          final page = await doc.getPage(1);
          final pageImage = await page.render();
          if (pageImage.imageIfAvailable != null) {
            await doc.dispose();
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: RawImage(
                image: pageImage.imageIfAvailable,
                fit: BoxFit.cover,
                width: 80,
                height: 80,
              ),
            );
          } else {
            await doc.dispose();
            return Icon(
              Icons.description,
              size: 50,
              color: const Color.fromRGBO(107, 114, 128, 1),
            );
          }
        }
      }
    } catch (e) {
      // If any error occurs during preview generation, fall back to the default icon
    }
    return Icon(
      defaultIcon,
      size: 50,
      color: const Color.fromRGBO(107, 114, 128, 1),
    );
  }
}

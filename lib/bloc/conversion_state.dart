import 'package:equatable/equatable.dart';
import 'package:libreconvert/models/conversion_task.dart';

class ConversionState extends Equatable {
  final String currentFileType;
  final String
  currentCategory; // Derived from fileType (Image, Audio, Video, Document)
  final List<ConversionTask> conversionTasks;
  final bool isConverting;
  final String? selectedFormat;
  final List<String> selectedFiles;

  const ConversionState({
    this.currentFileType = 'image',
    this.currentCategory = 'Image',
    this.conversionTasks = const [],
    this.isConverting = false,
    this.selectedFormat,
    this.selectedFiles = const [],
  });

  ConversionState copyWith({
    String? currentFileType,
    String? currentCategory,
    List<ConversionTask>? conversionTasks,
    bool? isConverting,
    String? selectedFormat,
    List<String>? selectedFiles,
  }) {
    return ConversionState(
      currentFileType: currentFileType ?? this.currentFileType,
      currentCategory: currentCategory ?? this.currentCategory,
      conversionTasks: conversionTasks ?? this.conversionTasks,
      isConverting: isConverting ?? this.isConverting,
      selectedFormat: selectedFormat ?? this.selectedFormat,
      selectedFiles: selectedFiles ?? this.selectedFiles,
    );
  }

  @override
  List<Object?> get props => [
    currentFileType,
    currentCategory,
    conversionTasks,
    isConverting,
    selectedFormat,
    selectedFiles,
  ];
}

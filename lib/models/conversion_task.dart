class ConversionTask {
  final String id;
  final String filePath;
  final String fileType;
  String targetFormat;
  String status;
  double progress;
  String? outputPath;
  String? errorMessage;
  Map<String, String>? customOptions;

  ConversionTask({
    required this.id,
    required this.filePath,
    required this.fileType,
    required this.targetFormat,
    this.status = 'Pending',
    this.progress = 0.0,
    this.outputPath,
    this.errorMessage,
    this.customOptions,
  });

  void updateStatus(String newStatus) {
    status = newStatus;
  }

  void updateProgress(double newProgress) {
    progress = newProgress;
  }

  void setOutputPath(String path) {
    outputPath = path;
  }

  void setError(String error) {
    errorMessage = error;
    status = 'Failed';
  }
}

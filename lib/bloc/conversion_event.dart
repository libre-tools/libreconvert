import 'package:equatable/equatable.dart';

abstract class ConversionEvent extends Equatable {
  const ConversionEvent();

  @override
  List<Object> get props => [];
}

class UpdateSelectedFiles extends ConversionEvent {
  final List<String> files;
  final List<String> extensions;

  const UpdateSelectedFiles(this.files, this.extensions);

  @override
  List<Object> get props => [files, extensions];
}

class UpdateSelectedFormat extends ConversionEvent {
  final String? format;

  const UpdateSelectedFormat(this.format);

  @override
  List<Object> get props => [format ?? ''];
}

class StartConversion extends ConversionEvent {
  final List<String> filePaths;

  const StartConversion(this.filePaths);

  @override
  List<Object> get props => [filePaths];
}

class ResetAppState extends ConversionEvent {
  const ResetAppState();
}

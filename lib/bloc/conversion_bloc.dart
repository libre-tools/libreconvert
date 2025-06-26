import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libreconvert/bloc/conversion_event.dart';
import 'package:libreconvert/bloc/conversion_state.dart';
import 'package:libreconvert/models/conversion_task.dart';
import 'package:libreconvert/utils/conversion_utils.dart';

class ConversionBloc extends Bloc<ConversionEvent, ConversionState> {
  ConversionBloc() : super(const ConversionState()) {
    on<UpdateSelectedFiles>(_onUpdateSelectedFiles);
    on<UpdateSelectedFormat>(_onUpdateSelectedFormat);
    on<StartConversion>(_onStartConversion);
    on<ResetAppState>(_onResetAppState);
  }

  void _onUpdateSelectedFiles(
    UpdateSelectedFiles event,
    Emitter<ConversionState> emit,
  ) {
    String currentFileType = 'image'; // Default
    String currentCategory = 'Image'; // Default
    if (event.extensions.isNotEmpty) {
      String ext = event.extensions[0].toLowerCase();
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
    emit(
      state.copyWith(
        selectedFiles: event.files,
        currentFileType: currentFileType,
        currentCategory: currentCategory,
      ),
    );
  }

  void _onUpdateSelectedFormat(
    UpdateSelectedFormat event,
    Emitter<ConversionState> emit,
  ) {
    emit(state.copyWith(selectedFormat: event.format));
  }

  Future<void> _onStartConversion(
    StartConversion event,
    Emitter<ConversionState> emit,
  ) async {
    if (state.isConverting || state.selectedFormat == null) return;

    emit(state.copyWith(isConverting: true));
    List<ConversionTask> tasks = [];
    for (var path in event.filePaths) {
      tasks.add(
        ConversionTask(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          filePath: path,
          fileType: state.currentFileType,
          targetFormat: state.selectedFormat!,
        ),
      );
    }
    emit(state.copyWith(conversionTasks: tasks));

    for (var task in tasks) {
      emit(
        state.copyWith(
          conversionTasks: state.conversionTasks.map((t) {
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
          }).toList(),
        ),
      );

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

      emit(
        state.copyWith(
          conversionTasks: state.conversionTasks.map((t) {
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
          }).toList(),
        ),
      );
    }

    emit(state.copyWith(isConverting: false));
  }

  void _onResetAppState(ResetAppState event, Emitter<ConversionState> emit) {
    emit(const ConversionState());
  }
}

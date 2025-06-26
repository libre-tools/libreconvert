import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libreconvert/ui/file_selector.dart';
import 'package:libreconvert/ui/format_selector.dart';
import 'package:libreconvert/ui/common/header_widget.dart';
import 'package:libreconvert/bloc/conversion_bloc.dart';
import 'package:libreconvert/bloc/conversion_event.dart';
import 'package:libreconvert/bloc/conversion_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, String>? currentCustomOptions;
  Map<String, Map<String, String>> savedPresets = {};

  void _updateSelectedFormat(String? format) {
    context.read<ConversionBloc>().add(UpdateSelectedFormat(format));
  }

  void _updateSelectedFiles(List<String> files, List<String> extensions) {
    context.read<ConversionBloc>().add(UpdateSelectedFiles(files, extensions));
  }

  void _startConversion(List<String> filePaths) {
    context.read<ConversionBloc>().add(StartConversion(filePaths));
  }

  void _resetAppState() {
    context.read<ConversionBloc>().add(const ResetAppState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16.0, right: 16.0),
        child: FloatingActionButton.extended(
          onPressed: _resetAppState,
          label: const Text(
            'Reset',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          icon: const Icon(Icons.refresh, color: Colors.white),
          backgroundColor: Theme.of(
            context,
          ).colorScheme.error, // Theme-based error color for action
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              8,
            ), // Consistent with shadcn design
          ),
          elevation: 2, // Subtle elevation for depth
        ),
      ),
      body: BlocBuilder<ConversionBloc, ConversionState>(
        builder: (context, state) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              margin: const EdgeInsets.all(24.0),
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height -
                    48.0, // Account for margin
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
                          if (state.selectedFiles.isNotEmpty)
                            Container(
                              width:
                                  200, // Constrain width to avoid unbounded constraints
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: FormatSelector(
                                  fileType: state.currentFileType,
                                  onFormatSelected: _updateSelectedFormat,
                                ),
                              ),
                            ),
                          const SizedBox(width: 10),
                          if (state.selectedFiles.isNotEmpty)
                            ElevatedButton(
                              onPressed:
                                  state.isConverting ||
                                      state.selectedFormat == null ||
                                      state.selectedFiles.isEmpty
                                  ? null
                                  : () {
                                      _startConversion(state.selectedFiles);
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primary, // Theme-based primary color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    8,
                                  ), // Consistent with shadcn design
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                elevation: 2, // Subtle elevation for depth
                              ),
                              child: const Text(
                                'Convert Files',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          // Settings button removed as per user request
                        ],
                      ),
                      const SizedBox(height: 30),
                      FileSelector(
                        onFilesSelected: _updateSelectedFiles,
                        conversionTasks: state.conversionTasks,
                      ),
                      const SizedBox(height: 30),
                      if (state.selectedFiles.isNotEmpty)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [],
                        ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

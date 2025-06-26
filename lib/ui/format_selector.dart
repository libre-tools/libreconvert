import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:libreconvert/bloc/conversion_bloc.dart';
import 'package:libreconvert/bloc/conversion_state.dart';

class FormatSelector extends StatefulWidget {
  final String fileType;
  final Function(String?) onFormatSelected;

  const FormatSelector({
    super.key,
    required this.fileType,
    required this.onFormatSelected,
  });

  @override
  State<FormatSelector> createState() => _FormatSelectorState();
}

class _FormatSelectorState extends State<FormatSelector> {
  String? selectedFormat;

  Map<String, List<String>> supportedFormats = {
    'Image': ['PNG', 'JPG', 'BMP'],
    'Audio': ['MP3', 'WAV', 'FLAC', 'OGG', 'AAC', 'M4A'],
    'Video': ['MP4', 'MKV', 'AVI', 'MOV', 'WMV', 'FLV', 'GIF'],
    'Document': [
      'PDF',
      'DOCX',
      'ODT',
      'RTF',
      'TXT',
      'HTML',
      'Markdown',
      'EPUB',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversionBloc, ConversionState>(
      builder: (context, state) {
        String category = state.currentCategory;

        // Only reset selectedFormat if it's not in the current category's format list
        // This ensures the dropdown retains the selection if valid for the new category
        if (selectedFormat != null &&
            !supportedFormats[category]!.any(
              (format) => format.toUpperCase() == selectedFormat,
            )) {
          selectedFormat = null;
        }

        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface.withValues(
                alpha: 0.2,
              ), // Theme-based border color
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(
              context,
            ).colorScheme.surface, // Theme-based background
            boxShadow: [
              BoxShadow(
                color: Theme.of(
                  context,
                ).colorScheme.shadow.withValues(alpha: 0.05),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          height: 48, // Set height to match convert button
          child: DropdownButton<String>(
            key: ValueKey<String>(category), // Force rebuild on category change
            value: selectedFormat,
            hint: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Choose Format',
                style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurfaceVariant, // Theme-based placeholder color
                  fontSize: 14,
                ),
              ),
            ),
            style: TextStyle(
              color: Theme.of(
                context,
              ).colorScheme.onSurface, // Theme-based text color
              fontSize: 14,
            ),
            dropdownColor: Theme.of(
              context,
            ).colorScheme.surface, // Theme-based dropdown background
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            items:
                supportedFormats[category]?.map((String format) {
                  return DropdownMenuItem<String>(
                    value: format
                        .toUpperCase(), // Ensure unique and consistent value
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(format),
                    ),
                  );
                }).toList() ??
                [],
            onChanged: (String? newValue) {
              setState(() {
                selectedFormat = newValue;
                widget.onFormatSelected(newValue);
              });
            },
            underline: const SizedBox.shrink(), // Remove default underline
            isExpanded: true, // Make dropdown fill the container width
            icon: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}

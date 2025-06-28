import 'package:shadcn_flutter/shadcn_flutter.dart';

class FormatSelector extends StatefulWidget {
  final String fileType;
  final String? sourceExtension;
  final Function(String?) onFormatSelected;

  const FormatSelector({
    super.key,
    required this.fileType,
    this.sourceExtension,
    required this.onFormatSelected,
  });

  @override
  State<FormatSelector> createState() => _FormatSelectorState();
}

class _FormatSelectorState extends State<FormatSelector> {
  String? selectedFormat;

  Map<String, List<String>> supportedFormats = {
    'Image': ['PNG', 'JPG', 'BMP', 'GIF', 'WEBP', 'HEIC', 'TIFF'],
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
    String category;
    if (widget.fileType == 'image') {
      category = 'Image';
    } else if (widget.fileType == 'audio') {
      category = 'Audio';
    } else if (widget.fileType == 'video') {
      category = 'Video';
    } else if (widget.fileType == 'document') {
      category = 'Document';
    } else {
      category = 'Image'; // Default fallback
    }

    // Only reset selectedFormat if it's not in the current category's format list
    if (selectedFormat != null &&
        !supportedFormats[category]!.any(
          (format) => format.toUpperCase() == selectedFormat,
        )) {
      selectedFormat = null;
    }

    return Select<String>(
      itemBuilder: (context, item) {
        return Text(item);
      },
      popupConstraints: const BoxConstraints(maxHeight: 300, maxWidth: 200),
      onChanged: (value) {
        setState(() {
          selectedFormat = value;
          widget.onFormatSelected(value);
        });
      },
      value: selectedFormat,
      placeholder: const Text('Choose Format'),
      popup: SelectPopup(
        items: SelectItemList(
          children:
              supportedFormats[category]
                  ?.where((format) {
                    if (widget.sourceExtension == null) return true;
                    String sourceExt = widget.sourceExtension!.toLowerCase();
                    String formatLower = format.toLowerCase();
                    // Handle special case for Markdown
                    if (sourceExt == 'md' || sourceExt == 'markdown') {
                      return formatLower != 'markdown';
                    }
                    return formatLower != sourceExt;
                  })
                  .map((String format) {
                    return SelectItemButton(
                      value: format.toUpperCase(),
                      child: Text(format),
                    );
                  })
                  .toList() ??
              [],
        ),
      ).call,
    );
  }
}

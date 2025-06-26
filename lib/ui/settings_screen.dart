import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final Function(Map<String, String>?) onCustomOptionsUpdated;
  final Function(String, Map<String, String>) onPresetSaved;

  const SettingsScreen({
    super.key,
    required this.onCustomOptionsUpdated,
    required this.onPresetSaved,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _ffmpegPathController = TextEditingController();
  final TextEditingController _pandocPathController = TextEditingController();
  final TextEditingController _presetNameController = TextEditingController();
  Map<String, String> customOptions = {};
  String selectedOptionType = 'ffmpeg'; // Default to FFmpeg options

  void _addCustomOption() {
    setState(() {
      customOptions['--new-option'] = ''; // Placeholder for new option
    });
  }

  void _updateCustomOptionKey(String oldKey, String newKey) {
    if (customOptions.containsKey(oldKey)) {
      final value = customOptions[oldKey];
      setState(() {
        customOptions.remove(oldKey);
        customOptions[newKey] = value ?? '';
      });
    }
  }

  void _updateCustomOptionValue(String key, String value) {
    setState(() {
      if (customOptions.containsKey(key)) {
        customOptions[key] = value;
      }
    });
  }

  void _removeCustomOption(String key) {
    setState(() {
      customOptions.remove(key);
    });
  }

  void _savePreset() {
    if (_presetNameController.text.isNotEmpty && customOptions.isNotEmpty) {
      widget.onPresetSaved(_presetNameController.text, Map.from(customOptions));
      setState(() {
        _presetNameController.clear();
        customOptions.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preset ${_presetNameController.text} saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings - OpenConvert',
          style: TextStyle(
            color: Color.fromRGBO(17, 24, 39, 1),
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: const Color.fromRGBO(0, 0, 0, 0.1),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromRGBO(107, 114, 128, 1),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Binary Paths',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(55, 65, 81, 1),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ffmpegPathController,
                decoration: InputDecoration(
                  labelText: 'FFmpeg Path (optional)',
                  hintText: 'Enter custom path to ffmpeg binary if not in PATH',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(37, 99, 235, 1),
                      width: 2,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _pandocPathController,
                decoration: InputDecoration(
                  labelText: 'Pandoc Path (optional)',
                  hintText: 'Enter custom path to pandoc binary if not in PATH',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(37, 99, 235, 1),
                      width: 2,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                  hintStyle: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 0.7),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Custom Conversion Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(55, 65, 81, 1),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(209, 213, 219, 1),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: DropdownButton<String>(
                      value: selectedOptionType,
                      hint: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Select Option Type',
                          style: TextStyle(
                            color: Color.fromRGBO(107, 114, 128, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      style: const TextStyle(
                        color: Color.fromRGBO(17, 24, 39, 1),
                        fontSize: 14,
                      ),
                      dropdownColor: Colors.white,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(8),
                      items: const [
                        DropdownMenuItem(
                          value: 'ffmpeg',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text('FFmpeg Options'),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'pandoc',
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Text('Pandoc Options'),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedOptionType = value;
                            customOptions =
                                {}; // Reset options when type changes
                          });
                          widget.onCustomOptionsUpdated(customOptions);
                        }
                      },
                      underline: const SizedBox.shrink(),
                      isExpanded: false,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color.fromRGBO(107, 114, 128, 1),
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _addCustomOption,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                    child: const Text('Add Option'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...customOptions.entries.map((entry) {
                final keyController = TextEditingController(text: entry.key);
                final valueController = TextEditingController(
                  text: entry.value,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: keyController,
                          decoration: InputDecoration(
                            labelText: 'Option',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(209, 213, 219, 1),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(209, 213, 219, 1),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(37, 99, 235, 1),
                                width: 2,
                              ),
                            ),
                            labelStyle: const TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                          onChanged: (newKey) =>
                              _updateCustomOptionKey(entry.key, newKey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: valueController,
                          decoration: InputDecoration(
                            labelText: 'Value (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(209, 213, 219, 1),
                                width: 1,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(209, 213, 219, 1),
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(37, 99, 235, 1),
                                width: 2,
                              ),
                            ),
                            labelStyle: const TextStyle(
                              color: Color.fromRGBO(107, 114, 128, 1),
                            ),
                          ),
                          onChanged: (newValue) =>
                              _updateCustomOptionValue(entry.key, newValue),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.remove,
                          color: Color.fromRGBO(239, 68, 68, 1),
                        ),
                        onPressed: () => _removeCustomOption(entry.key),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: customOptions.isNotEmpty
                    ? () {
                        widget.onCustomOptionsUpdated(customOptions);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Custom options updated'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Apply Custom Options'),
              ),
              const SizedBox(height: 24),
              const Text(
                'Save Preset',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(55, 65, 81, 1),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _presetNameController,
                decoration: InputDecoration(
                  labelText: 'Preset Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(209, 213, 219, 1),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(37, 99, 235, 1),
                      width: 2,
                    ),
                  ),
                  labelStyle: const TextStyle(
                    color: Color.fromRGBO(107, 114, 128, 1),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed:
                    customOptions.isNotEmpty &&
                        _presetNameController.text.isNotEmpty
                    ? _savePreset
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  textStyle: const TextStyle(fontSize: 14),
                ),
                child: const Text('Save as Preset'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

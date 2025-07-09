import 'package:flutter/material.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:libreconvert/ui/home_screen.dart'; // Will navigate to this screen
import 'package:libreconvert/utils/tool_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:logger/logger.dart'; // Added logger import

final logger = Logger(); // Initialize logger

class ToolCheckScreen extends StatefulWidget {
  const ToolCheckScreen({super.key});

  @override
  State<ToolCheckScreen> createState() => _ToolCheckScreenState();
}

class _ToolCheckScreenState extends State<ToolCheckScreen>
    with TickerProviderStateMixin {
  List<String> _missingTools = [];
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween(begin: 0.5, end: 1.0).animate(_controller);
    _checkTools();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkTools() async {
    final installedTools = await ToolChecker.checkAllTools();
    final missingTools = installedTools.entries
        .where((entry) => !entry.value)
        .map((entry) => entry.key)
        .toList();

    if (missingTools.isEmpty) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } else {
      if (mounted) {
        setState(() {
          _missingTools = missingTools;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_missingTools.isNotEmpty) {
      return Material(
        child: Center(
          child: SingleChildScrollView(
            // Added SingleChildScrollView
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.build_circle_outlined,
                  color: Colors.orange,
                  size: 80,
                ),
                shadcn.gap(20),
                Text(
                  'Action Required: Missing Tools',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0, // Adjusted for window size
                  ),
                  textAlign: TextAlign.center,
                ),
                shadcn.gap(15),
                Text(
                  'LibreConvert requires the following command-line tools to function. Please install them to proceed:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 13.0,
                  ), // Adjusted for window size
                  textAlign: TextAlign.center,
                ),
                shadcn.gap(20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _missingTools.map((tool) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.close, color: Colors.red, size: 20),
                          shadcn.gap(8),
                          Text(
                            tool,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.red,
                                  fontSize: 15.0,
                                ), // Adjusted for window size
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                shadcn.gap(30),
                shadcn.PrimaryButton(
                  onPressed: () async {
                    const url = 'https://github.com/libre-tools/libreconvert';
                    if (await canLaunchUrl(Uri.parse(url))) {
                      await launchUrl(Uri.parse(url));
                    } else {
                      // Handle error: could not launch URL
                      logger.e('Could not launch $url');
                    }
                  },
                  child: const Text('Install'),
                ),
                shadcn.gap(10), // Gap between buttons
                shadcn.PrimaryButton(
                  onPressed: () {
                    setState(() {
                      _missingTools =
                          []; // Clear missing tools to show loading state again
                    });
                    _checkTools();
                  },
                  child: const Text('Retry Check'),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Material(
        child: SizedBox.expand(
          // Force Column to take full screen
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RotationTransition(
                        turns: _controller,
                        child: const Icon(
                          Icons.settings,
                          size: 40,
                          color: Colors.blue,
                        ), // Slightly increased size for prominence
                      ),
                      shadcn.gap(10), // Adjusted gap
                      FadeTransition(
                        opacity: _animation,
                        child: Text(
                          'Checking required tools...',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontSize: 15.0,
                              ), // Adjusted for prominence
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}

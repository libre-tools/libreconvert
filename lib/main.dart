import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:libreconvert/ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.setResizable(false);
  const Size windowSize = Size(800, 450);
  windowManager.setSize(windowSize);
  windowManager.setMinimumSize(windowSize);
  windowManager.setMaximumSize(windowSize);

  windowManager.setTitleBarStyle(TitleBarStyle.normal);
  windowManager.setTitle('LibreConvert');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return shadcn.ShadcnApp(
      title: 'LibreConvert',
      theme: shadcn.ThemeData(
        colorScheme: shadcn.ColorSchemes.lightBlue(),
        radius: 0.5,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}

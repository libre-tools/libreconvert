import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:libreconvert/ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.setResizable(false);

  windowManager.setTitleBarStyle(TitleBarStyle.normal);
  windowManager.setTitle('LibreConvert');

  runApp(const MyApp());
  await windowManager.show();
  await windowManager.focus();
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart' as shadcn;
import 'package:libreconvert/ui/home_screen.dart';
import 'package:libreconvert/bloc/conversion_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  windowManager.setResizable(false);

  windowManager.setTitleBarStyle(TitleBarStyle.normal);
  windowManager.setBackgroundColor(
    Colors.white,
  ); // Matches default light theme background
  runApp(const LibreConvertApp());
}

class LibreConvertApp extends StatelessWidget {
  const LibreConvertApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConversionBloc(),
      child: shadcn.ShadcnApp(
        title: 'libreconvert',
        theme: shadcn.ThemeData(
          colorScheme: shadcn.ColorSchemes.lightNeutral(),
          radius: 0.5,
        ),
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
      ),
    );
  }
}

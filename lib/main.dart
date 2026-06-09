import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/sequence_optimizer_provider.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const NeuroRutaApp());
}

class NeuroRutaApp extends StatelessWidget {
  const NeuroRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SequenceOptimizerProvider()..loadHistory(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Neuro Ciencia SC',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xff00b8c4),
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xfff6fffe),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff00b8c4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff008c95),
              side: const BorderSide(color: Color(0xff06d6a0)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        home: const LoginScreen(),
      ),
    );
  }
}

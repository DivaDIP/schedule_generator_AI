import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:schedule_generator_ai/ui/home/home_screen.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint("Warning: .env file not found");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schedule Generator App',
      theme: baseTheme.copyWith(
        scaffoldBackgroundColor: baseTheme.colorScheme.surfaceContainerLowest,
        appBarTheme: baseTheme.appBarTheme.copyWith(
          surfaceTintColor: Colors.transparent,
          backgroundColor: baseTheme.colorScheme.surfaceContainerLowest,
          elevation: 0,
          titleTextStyle: baseTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: baseTheme.colorScheme.onSurface,
          ),
        ),
        cardTheme: baseTheme.cardTheme.copyWith(
          color: baseTheme.colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: baseTheme.colorScheme.outlineVariant),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: baseTheme.colorScheme.surfaceContainerLow,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: baseTheme.colorScheme.outlineVariant),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: baseTheme.colorScheme.outlineVariant),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: baseTheme.colorScheme.primary),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        chipTheme: baseTheme.chipTheme.copyWith(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          side: BorderSide(color: baseTheme.colorScheme.outlineVariant),
          backgroundColor: baseTheme.colorScheme.surfaceContainerLow,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
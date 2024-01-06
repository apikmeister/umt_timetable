import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable/theme/app_theme.dart';
import 'package:umt_timetable/views/screens/create_timetable_screen.dart';
import 'package:umt_timetable/views/screens/main_screen.dart';
import 'package:umt_timetable/views/screens/onboarding_screen.dart';
import 'package:umt_timetable/views/screens/select_program_screen.dart';
import 'package:umt_timetable/views/screens/view_timetable_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => NewTimetableProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/onboarding',
        routes: {
          '/home': (context) => const HomeScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
          '/choose_program': (context) => const SelectProgram(),
          '/view_timetable': (context) => const TimetableScreen(),
          '/create_timetable': (context) => const CreateTimetable(),
        },
        title: 'UMT Timetable',
        theme: buildLightTheme(context),
        darkTheme: buildDarkTheme(context),
        home: const HomeScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

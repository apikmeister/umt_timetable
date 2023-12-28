import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable/screens/create_timetable_screen.dart';
import 'package:umt_timetable/screens/main_screen.dart';
import 'package:umt_timetable/screens/onboarding_screen.dart';
import 'package:umt_timetable/screens/select_program_screen.dart';
import 'package:umt_timetable/screens/view_timetable_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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
        title: 'Flutter Calendar UI',
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

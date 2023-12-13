import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable/screens/create_timetable_screen.dart';
import 'package:umt_timetable/screens/main_screen.dart';
import 'package:umt_timetable/screens/onboarding_screen.dart';
import 'package:umt_timetable/screens/select_program_screen.dart';
import 'package:umt_timetable/screens/view_timetable_screen.dart';
import 'package:umt_timetable/theme/app_theme.dart';
import 'package:umt_timetable_parser/src/util/get_timetables.dart';

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
          '/home': (context) =>
              HomeScreen(), //TODO: Change this to '/onboarding
          '/onboarding': (context) => OnboardingScreen(),
          '/choose_program': (context) => SelectProgram(),
          '/view_timetable': (context) => TimetableScreen(),
          '/create_timetable': (context) => CreateTimetable(),
        },
        title: 'Flutter Calendar UI',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

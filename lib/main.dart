import 'dart:io';

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
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
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
        title: 'UMT Timetable',
        theme: ThemeData.light().copyWith(
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ),
          appBarTheme: AppBarTheme(
            color: Colors.transparent,
            foregroundColor: Colors.black,
            elevation: 0,
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            titleTextStyle: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
            // TextStyle(
            //   color: Colors.black,
            //   fontSize: 24,
            //   fontWeight: FontWeight.w600,
            // ),
          ),
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.deepPurple,
            selectionColor: Colors.deepPurple.withOpacity(0.4),
            selectionHandleColor: Colors.deepPurple,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Color(0xFFF5F5F5),
            hintStyle: TextStyle(
              color: Color(0xFFB8B5C3),
            ),
            border: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            enabledBorder: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            focusedBorder: OutlineInputBorder(
              // borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              // primary: primaryColor,
              primary: Colors.black87,
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              primary: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
          ),
          radioTheme: RadioThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return Colors.purple; // the color when radio button is selected
              }
              return Colors.grey; // the color when radio button is unselected
            }),
          ),
          expansionTileTheme: const ExpansionTileThemeData(
            iconColor: Colors.black,
            textColor: Colors.black,
            expandedAlignment: Alignment.centerLeft,
          ),
        ),
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

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// themedata for light mode
ThemeData buildLightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
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
        backgroundColor: Colors.black87,
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.black,
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
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
  );
}

// themedata for dark mode
ThemeData buildDarkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    textTheme: GoogleFonts.interTextTheme(
      Theme.of(context)
          .textTheme
          .apply(bodyColor: Colors.white, displayColor: Colors.white),
    ),
    appBarTheme: AppBarTheme(
      color: Colors.black, // Adjusted for dark theme
      foregroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      titleTextStyle: GoogleFonts.inter(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.deepPurple,
      selectionColor: Colors.deepPurple.withOpacity(0.4),
      selectionHandleColor: Colors.deepPurple,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF303030), // Adjusted for dark theme
      hintStyle: TextStyle(
        color: Color(0xFFB8B5C3),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Adjusted for dark theme
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white, // Adjusted for dark theme
        minimumSize: const Size(double.infinity, 56),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor:
          MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return Colors.deepPurple; // Adjusted for dark theme
        }
        return Colors.grey; // Adjusted for dark theme
      }),
    ),
    expansionTileTheme: const ExpansionTileThemeData(
      iconColor: Colors.white, // Adjusted for dark theme
      textColor: Colors.white, // Adjusted for dark theme
      expandedAlignment: Alignment.centerLeft,
    ),
  );
}

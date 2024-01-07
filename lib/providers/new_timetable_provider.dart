import 'package:flutter/material.dart';

class NewTimetableProvider extends ChangeNotifier {
  String? _selectedSession;
  String? _selectedProgram;
  String? _selectedYear;
  String? _timetableName;
  Map<String, String?>? unselectedGroups;

  // getters
  String? get selectedSession => _selectedSession;
  String? get selectedProgram => _selectedProgram;
  String? get selectedYear => _selectedYear;
  String? get timetableName => _timetableName;
  Map<String, String?>? get unselectedGroup => unselectedGroups;

  // setters
  void setTimetableName(String timetableName) {
    _timetableName = timetableName;
    notifyListeners();
  }

  void setUnselectedGroup(Map<String, String?> unselectedGroup) {
    unselectedGroups = unselectedGroup;
    notifyListeners();
  }

  void setSelectedYear(String year) {
    _selectedYear = year;
    notifyListeners();
  }

  void setSelectedProgram(String program) {
    _selectedProgram = program;
    notifyListeners();
  }

  void setSelectedSession(String session) {
    _selectedSession = session;
    notifyListeners();
  }

  // reset the selected session
  void resetSelectedSession() {
    _selectedSession = null;
    notifyListeners();
  }
}

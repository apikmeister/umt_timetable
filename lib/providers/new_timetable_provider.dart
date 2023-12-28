import 'package:flutter/material.dart';

class NewTimetableProvider extends ChangeNotifier {
  // String selectedSemester = '';
  String? _selectedSession;
  String? _selectedProgram;
  String? _selectedYear;
  Map<String, String?>? unselectedGroups;

  String? get selectedSession => _selectedSession;
  String? get selectedProgram => _selectedProgram;
  String? get selectedYear => _selectedYear;
  Map<String, String?>? get unselectedGroup => unselectedGroups;

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

  // void setSelectedSemester(String semester) {
  //   selectedSemester = semester;
  //   notifyListeners();
  // }
}

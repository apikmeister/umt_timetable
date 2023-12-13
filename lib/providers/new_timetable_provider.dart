import 'package:flutter/material.dart';

class NewTimetableProvider extends ChangeNotifier {
  // String selectedSemester = '';
  String? _selectedSession;
  String? _selectedProgram;

  String? get selectedSession => _selectedSession;
  String? get selectedProgram => _selectedProgram;

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

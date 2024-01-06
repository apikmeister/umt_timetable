import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';

class NewTimetableProvider extends ChangeNotifier {
  // String selectedSemester = '';
  String? _selectedSession;
  String? _selectedProgram;
  String? _selectedYear;
  String? _timetableName;
  Map<String, String?>? unselectedGroups;

  Map<String, List<LaneEvents>>? timetableEvents;
  bool _loading = false;

  String? get selectedSession => _selectedSession;
  String? get selectedProgram => _selectedProgram;
  String? get selectedYear => _selectedYear;
  String? get timetableName => _timetableName;
  Map<String, String?>? get unselectedGroup => unselectedGroups;

  Map<String, List<LaneEvents>>? get timetableEvent => timetableEvents;
  bool get loading => _loading;

  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void addTimetableEvent(String key, List<LaneEvents> events) {
    if (timetableEvents == null) {
      timetableEvents = {};
    }
    timetableEvents![key] = events;
    notifyListeners();
  }

  void deleteTimetableEvent(String key) {
    timetableEvents!.remove(key);
    notifyListeners();
  }

  void setTimetableEvent(Map<String, List<LaneEvents>> timetableEvent) {
    timetableEvents = timetableEvent;
    notifyListeners();
  }

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

  // void setSelectedSemester(String semester) {
  //   selectedSemester = semester;
  //   notifyListeners();
  // }
}

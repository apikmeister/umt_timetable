import 'dart:convert';

import 'package:umt_timetable_parser/umt_timetable_parser.dart';

// This is the service class that will be used to get the data from the UMT website
class TimetableService {
  // function to get faculty data from the UMT website
  Future<List<Faculty>> getFaculties(String session) async {
    String programJson = await getProgram(session);
    Map<String, dynamic> data = jsonDecode(programJson);
    List<Faculty> faculties = List<Faculty>.from(data.values
        .map((model) => Faculty.fromJson(model))
        .where((program) => program.facultyName.isNotEmpty)
        .toList());
    return faculties;
  }

  // function to get program data from the UMT website based on the faculty
  Future<List<Program>> getPrograms(String session, String faculty) async {
    String programJson = await getProgram(session);
    Map<String, dynamic> data = jsonDecode(programJson);
    Faculty selectedFacultyObject = Faculty.fromJson(data[faculty]);
    List<Program> programs = selectedFacultyObject.programs;
    return programs;
  }
}

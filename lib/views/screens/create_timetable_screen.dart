import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';

class CreateTimetable extends StatefulWidget {
  const CreateTimetable({super.key});

  @override
  State<CreateTimetable> createState() => _CreateTimetableState();
}

class _CreateTimetableState extends State<CreateTimetable> {
  String? selectedStudyGrade;
  String? selectedSemester;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 15.0, left: 15.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Create\nNew Timetable',
              style: GoogleFonts.inter(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '*Please select your study grade and semester',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Study Grade'),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: _studyGradeDropdown(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Semester',
                    ),
                    const SizedBox(height: 10),
                    _semesterDropdown(),
                  ],
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                var newTimetableProvider =
                    Provider.of<NewTimetableProvider>(context, listen: false);
                if (newTimetableProvider.selectedSession == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select your study grade and semester',
                      ),
                      duration: Duration(seconds: 1),
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, '/choose_program');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  // build dropdown menu for semester based on selected study grade
  Widget _semesterDropdown() {
    return FutureBuilder(
      future: () async {
        if (selectedStudyGrade == null) {
          return const SizedBox.shrink();
        }
        try {
          String timetableJson = await getSemester();

          Iterable l = jsonDecode(timetableJson);

          List<Semester> entries = l
              .map((model) => Semester.fromJson(model as Map<String, dynamic>))
              .toList();
          List<Semester> filteredEntries = entries
              .where((entry) => entry.studyGrade == selectedStudyGrade)
              .toList();

          List<DropdownMenuEntry> dropdownMenuItems =
              filteredEntries.map((Semester entry) {
            return DropdownMenuEntry(
              label: entry.semesterName,
              value: entry.semesterCode,
            );
          }).toList();

          return DropdownMenu(
            dropdownMenuEntries: dropdownMenuItems,
            hintText: "Semester",
            onSelected: (value) {
              Provider.of<NewTimetableProvider>(context, listen: false)
                  .setSelectedSession(value);
            },
          );
        } catch (e) {
          return Text('Error: ${e.toString()}');
        }
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return snapshot.data!;
        }
      },
    );
  }

  // build dropdown menu for study grade fetch from the UMT website
  Future<Widget> _studyGradeDropdown() async {
    try {
      String timetableJson = await getSemester();

      Iterable l = jsonDecode(timetableJson);

      List<Semester> entries = l
          .map((model) => Semester.fromJson(model as Map<String, dynamic>))
          .toList();

      // Create a set of unique study grades
      Set<String> uniqueStudyGrades =
          entries.map((entry) => entry.studyGrade).toSet();

      List<DropdownMenuEntry> dropdownMenuItems =
          uniqueStudyGrades.map((String studyGrade) {
        return DropdownMenuEntry(
          label: studyGrade,
          value: studyGrade,
        );
      }).toList();

      return DropdownMenu(
        dropdownMenuEntries: dropdownMenuItems,
        hintText: "Study Grade",
        onSelected: (value) {
          Provider.of<NewTimetableProvider>(context, listen: false)
              .resetSelectedSession();
          setState(() {
            selectedStudyGrade = value;
            selectedSemester = null;
          });
        },
      );
    } catch (e) {
      return Text('Error: ${e.toString()}');
    }
  }
}

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
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create\nNew Timetable',
              style: GoogleFonts.inter(
                // textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Text('Study Grade'),
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
                // FutureBuilder(future: _dropdownSemester(), builder: builder)
                // _dropdownSemester(),
                FutureBuilder(
                  future: _semesterDropdown(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return snapshot.data!;
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/choose_program');
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _semesterDropdown() async {
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

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Semester',
          ),
          const SizedBox(height: 10),
          DropdownMenu(
            dropdownMenuEntries: dropdownMenuItems,
            hintText: "Semester",
            onSelected: (value) {
              Provider.of<NewTimetableProvider>(context, listen: false)
                  .setSelectedSession(value);
              setState(() {
                selectedSemester = value;
              });
              // setState(() {
              //   selectedSemester = value!;
              // });
            },
          ),
        ],
      );
    } catch (e) {
      return Text('Error: ${e.toString()}');
    }
  }

  // List<DropdownMenuEntry> _semesterDropdown() {
  //   List<DropdownMenuEntry> dropdownMenuItems = [];
  //   if (selectedStudyGrade == null) {
  //     return []; // Return an empty widget if no study grade is selected
  //   }

  //   FutureBuilder(
  //     future:
  //         getSemester(), // Replace this with the actual method that fetches the data
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       }

  //       Iterable l = jsonDecode(snapshot.data as String);
  //       List<Semester> filteredEntries = l
  //           .map((model) => Semester.fromJson(model as Map<String, dynamic>))
  //           .toList()
  //           .where((entry) => entry.studyGrade == selectedStudyGrade)
  //           .toList();

  //       // List<DropdownMenuEntry> dropdownMenuItems =
  //       //     filteredEntries.map((Semester entry) {
  //       //   return DropdownMenuEntry(
  //       //     label: entry.semesterName,
  //       //     value: entry.semesterCode,
  //       //   );
  //       // }).toList();

  //       dropdownMenuItems = filteredEntries.map((Semester entry) {
  //         return DropdownMenuEntry(
  //           label: entry.semesterName,
  //           value: entry.semesterCode,
  //         );
  //       }).toList();

  //       return Container();

  //       // return DropdownMenu(
  //       //   dropdownMenuEntries: dropdownMenuItems,
  //       //   hintText: "Semester",
  //       //   onSelected: (value) {
  //       //     setState(() {
  //       //       // selectedStudyGrade = value;
  //       //       selectedSemester = value;
  //       //     });
  //       //   },
  //       // );
  //     },
  //   );
  //   return dropdownMenuItems;
  // }

  // Widget _dropdownSemester() {
  //   return DropdownMenu(
  //     dropdownMenuEntries: _semesterDropdown(),
  //     hintText: "Semester",
  //     onSelected: (value) {
  //       setState(() {
  //         // selectedStudyGrade = value;
  //         selectedSemester = value;
  //       });
  //     },
  //   );
  // }

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
          setState(() {
            selectedStudyGrade = value;
            selectedSemester = null;
          });
          // setState(() {
          //   selectedStudyGrade = value!;
          // });
        },
      );
    } catch (e) {
      return Text('Error: ${e.toString()}');
    }
  }

  // return FutureBuilder<List<String>>(
  //   future: marinerBase.getSemester(),
  //   builder: (context, snapshot) {
  //     if (snapshot.connectionState == ConnectionState.waiting) {
  //       return CircularProgressIndicator();
  //     } else if (snapshot.hasError) {
  //       return Text('Error: ${snapshot.error}');
  //     } else {
  //       return Container(
  //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10.0),
  //           border: Border.all(
  //             color: Colors.grey.withOpacity(0.5),
  //             width: 1.0,
  //           ),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton<String>(
  //             value: _semester,
  //             isExpanded: true,
  //             items: snapshot.data.map((String value) {
  //               return DropdownMenuItem<String>(
  //                 value: value,
  //                 child: Text(value),
  //               );
  //             }).toList(),
  //             onChanged: (String value) {
  //               setState(() {
  //                 _semester = value;
  //               });
  //             },
  //           ),
  //         ),
  //       );
  //     }
  //   },
  // );
}

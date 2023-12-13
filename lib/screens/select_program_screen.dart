import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';

class SelectProgram extends StatefulWidget {
  const SelectProgram({super.key});

  @override
  State<SelectProgram> createState() => _SelectProgramState();
}

class _SelectProgramState extends State<SelectProgram> {
  String? sessCode;
  String? selectedFaculty;
  String? selectedProgram;
  ValueNotifier<String?> selectedFacultyNotifier = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Choose Program',
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FutureBuilder(
                future: _facultyDropdown(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data!;
                  } else if (snapshot.hasError) {
                    return const Text('Error');
                  }
                  return const Text('Loading...');
                }),
            if (selectedFaculty != null)
              FutureBuilder(
                future: _programList(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading...'); // Show loading indicator
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data!;
                      }
                    default:
                      return SizedBox.shrink();
                  }
                },
                //   if (snapshot.hasData) {
                //     return snapshot.data!;
                //   } else if (snapshot.hasError) {
                //     return const Text('Error');
                //   }
                //   return const Text('Loading...');
                // },
              ),
            // ElevatedButton(
            //   onPressed: (selectedFaculty != null && selectedProgram != null)
            //       ? () {
            //           Navigator.pushNamed(context, '/view_timetable',
            //               arguments: {
            //                 'studyGrade': selectedProgram,
            //                 'semester': '1',
            //               });
            //         }
            //       : null,
            //   child: Text('Generate Timetable'),
            // ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _facultyDropdown() async {
    try {
      String programJson = await getProgram("S202324-I");
      Map<String, dynamic> data = jsonDecode(programJson);
      // List<Faculty> programs = List<Faculty>.from(
      //     data.values.map((model) => Faculty.fromJson(model)).toList());
      List<Faculty> faculty = List<Faculty>.from(data.values
          .map((model) => Faculty.fromJson(model))
          .where((program) => program != null && program.facultyName.isNotEmpty)
          .toList());

      List<DropdownMenuEntry> dropdownMenuEntries = faculty.map((program) {
        return DropdownMenuEntry(
          label: program.facultyName,
          // child: Text(program.name),
          value: program.facultyName,
        );
      }).toList();

      return DropdownMenu(
        dropdownMenuEntries: dropdownMenuEntries,
        hintText: 'Fakulti',
        onSelected: (value) {
          setState(() {
            // selectedProgram = value;
            selectedFaculty = value;
          });
        },
      );
    } catch (e) {
      return Text('Error: ${e.toString()}');
    }
  }

  Future<Widget> _programList() async {
    try {
      String programJson = await getProgram("S202324-I");
      Map<String, dynamic> data = jsonDecode(programJson);
      // List<Faculty> programs = List<Faculty>.from(
      //     data.values.map((model) => Faculty.fromJson(model)).toList());
      Faculty selectedFacultyObject = Faculty.fromJson(data[selectedFaculty]);
      List<Program> programs = selectedFacultyObject.programs;
      // List<Faculty> programs = List<Faculty>.from(data.values
      //     .map((model) => Faculty.fromJson(model))
      //     .where((program) =>
      //         program != null &&
      //         program.facultyName == selectedFaculty &&
      //         program.facultyName.isNotEmpty)
      //     .toList());

      return Expanded(
        child: ListView.builder(
          itemCount: programs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                programs[index].programName,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () {
                Provider.of<NewTimetableProvider>(context, listen: false)
                    .setSelectedProgram(programs[index].programCode);
                setState(() {
                  selectedProgram = programs[index].programCode;
                });
                Navigator.pushNamed(context, '/view_timetable');
                // Navigator.pushNamed(context, '/view_timetable', arguments: {
                //   'studyGrade': programs[index].studyGrade,
                //   'semester': programs[index].semester,
              },
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 15,
              ),
            );
          },
        ),
      );
    } catch (e) {
      return Text('Error: ${e.toString()}');
    }
  }
}

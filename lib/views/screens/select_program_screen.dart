import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable/services/timetable_service.dart';
import 'package:umt_timetable/views/widgets/program_modal.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SelectProgram extends StatefulWidget {
  const SelectProgram({super.key});

  @override
  State<SelectProgram> createState() => _SelectProgramState();
}

class _SelectProgramState extends State<SelectProgram> {
  final timetableService = TimetableService();
  String? sessCode;
  String? selectedFaculty;
  String? selectedProgram;

  ValueNotifier<String?> selectedFacultyNotifier = ValueNotifier<String?>(null);

  final pageIndexNotifier = ValueNotifier(0);

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
            Text('Faculty', style: GoogleFonts.inter(fontSize: 16)),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            if (selectedFaculty != null)
              FutureBuilder(
                future: _programList(),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('Loading...'); // Show loading indicator
                    case ConnectionState.done:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return snapshot.data!;
                      }
                    default:
                      return const SizedBox.shrink();
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  Future<Widget> _facultyDropdown() async {
    try {
      List<Faculty> faculties = await timetableService.getFaculties(
        Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
      );

      List<DropdownMenuEntry> dropdownMenuEntries = faculties.map((program) {
        return DropdownMenuEntry(
          label: program.facultyName,
          value: program.facultyName,
        );
      }).toList();

      return DropdownMenu(
        dropdownMenuEntries: dropdownMenuEntries,
        hintText: 'Fakulti',
        onSelected: (value) {
          setState(() {
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
      List<Program> programs = await timetableService.getPrograms(
        Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
        selectedFaculty!,
      );

      return Expanded(
        child: ListView.builder(
          itemCount: programs.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                programs[index].programName,
                style: const TextStyle(fontSize: 14),
              ),
              onTap: () async {
                Provider.of<NewTimetableProvider>(context, listen: false)
                    .setSelectedProgram(programs[index].programCode);
                // _yearSelector(context, tahunList);
                await WoltModalSheet.show(
                  context: context,
                  pageListBuilder: (modalSheetContext) {
                    final textTheme = Theme.of(context).textTheme;
                    return [
                      studyYearPage(
                          modalSheetContext, textTheme, pageIndexNotifier),
                    ];
                  },
                  onModalDismissedWithBarrierTap: () {
                    Navigator.of(context).pop();
                    pageIndexNotifier.value = 0;
                  },
                  maxDialogWidth: 560,
                  minDialogWidth: 400,
                  minPageHeight: 0.0,
                  maxPageHeight: 0.9,
                );
              },
              trailing: const Icon(
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

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class SelectProgram extends StatefulWidget {
  const SelectProgram({super.key});

  @override
  State<SelectProgram> createState() => _SelectProgramState();
}

class _SelectProgramState extends State<SelectProgram> {
  String? sessCode;
  String? selectedFaculty;
  String? selectedProgram;
  Map<String, String?> selectedGroups = {};
  Map<String, String?> unselectedGroups = {};
  ValueNotifier<String?> selectedFacultyNotifier = ValueNotifier<String?>(null);
  bool canProceed = false;

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
      String programJson = await getProgram(
          Provider.of<NewTimetableProvider>(context, listen: false)
              .selectedSession!);
      Map<String, dynamic> data = jsonDecode(programJson);
      List<Faculty> faculty = List<Faculty>.from(data.values
          .map((model) => Faculty.fromJson(model))
          .where((program) => program.facultyName.isNotEmpty)
          .toList());

      List<DropdownMenuEntry> dropdownMenuEntries = faculty.map((program) {
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
      String programJson = await getProgram(
          Provider.of<NewTimetableProvider>(context, listen: false)
              .selectedSession!);
      Map<String, dynamic> data = jsonDecode(programJson);
      Faculty selectedFacultyObject = Faculty.fromJson(data[selectedFaculty]);
      List<Program> programs = selectedFacultyObject.programs;
      // var selectedByUser =
      //     Provider.of<NewTimetableProvider>(context, listen: false);

      //THIS IS FOR TAHUN
      // var marinerBase = MarinerBase(
      //     session: selectedByUser.selectedSession!,
      //     program: selectedByUser.selectedProgram!);
      // String timetableJson = await marinerBase.getTimetable();

      // Iterable l = jsonDecode(timetableJson);
      // List<MarineSchedule> entries = List<MarineSchedule>.from(
      //     l.map((model) => MarineSchedule.fromJson(model)));
      // // List<String> tahunList =
      // //     entries.map((entry) => entry.tahun).toSet().toList();

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
                      page1(modalSheetContext, textTheme),
                    ];
                  },
                  onModalDismissedWithBarrierTap: () {
                    debugPrint('Closed modal sheet with barrier tap');
                    Navigator.of(context).pop();
                    pageIndexNotifier.value = 0;
                  },
                  maxDialogWidth: 560,
                  minDialogWidth: 400,
                  minPageHeight: 0.0,
                  maxPageHeight: 0.9,
                );
                // showTahunDialog(); //TODO: maybe change this or nah
                // showTahunDialog(context);
                // print(tahunList);
                // print(timetableJson);
                // Provider.of<NewTimetableProvider>(context, listen: false)
                //     .setSelectedProgram(programs[index].programCode);
                // setState(() {
                //   selectedProgram = programs[index].programCode;
                // });
                // Navigator.pushNamed(context, '/view_timetable');
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

  void showTahunDialog() {
    var marinerBase = MarinerBase(
        session: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
        program: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedProgram!);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FutureBuilder(
          future: marinerBase.getTimetable(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              String timetableJson = snapshot.data as String;
              Iterable l = jsonDecode(timetableJson);
              List<MarineSchedule> entries = List<MarineSchedule>.from(
                  l.map((model) => MarineSchedule.fromJson(model)));
              List<String> tahunList =
                  entries.map((entry) => entry.tahun).toSet().toList();
              return AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 100),
                curve: Curves.decelerate,
                child: SizedBox(
                  height: 350,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Tahun',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tahunList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(tahunList[index]),
                              onTap: () {
                                Provider.of<NewTimetableProvider>(context,
                                        listen: false)
                                    .setSelectedYear(tahunList[index]);
                                showDuplicateDialog(entries);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return const Text('Error');
            }
            return Container(
              height: 200,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }

  void showDuplicateDialog(List<MarineSchedule> entries) {
    var year =
        Provider.of<NewTimetableProvider>(context, listen: false).selectedYear;
    List<String> courses = entries
        .where((entry) => entry.tahun == year && entry.elektif == false)
        .map((entry) => entry.course)
        .toSet()
        .toList();
    Map<String, List<String>> groupsByCourse = {};
    for (String course in courses) {
      List<String> groups = entries
          .where((entry) => entry.course == course)
          .map((entry) => entry.group)
          .toSet()
          .toList();
      groupsByCourse[course] = groups;
    }
    List<dynamic> coursesWithMultipleGroups = [];
    for (String course in groupsByCourse.keys) {
      if (groupsByCourse[course]!.length > 1) {
        coursesWithMultipleGroups.add(course);
      }
    }

    for (String course in coursesWithMultipleGroups) {
      selectedGroups[course] =
          null; // Initially, no group is selected for each course
      unselectedGroups[course] = null;
    }
    coursesWithMultipleGroups.isEmpty
        ? Navigator.pushNamed(context, '/view_timetable')
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                // Use StatefulBuilder to update the state of the dialog
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Duplicate Courses'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: coursesWithMultipleGroups.map((course) {
                          return ExpansionTile(
                            // Use ExpansionTile to show the groups when the course is tapped
                            title: Text(course),
                            children: groupsByCourse[course]!.map((group) {
                              return RadioListTile.adaptive(
                                title: Text(group),
                                value: group,
                                groupValue: selectedGroups[course],
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedGroups[course] = value;
                                    print(selectedGroups[course]);

                                    unselectedGroups[course] =
                                        groupsByCourse[course]
                                            ?.where((group) => group != value)
                                            .toList()
                                            .join(', ');
                                    Provider.of<NewTimetableProvider>(context,
                                            listen: false)
                                        .setUnselectedGroup(unselectedGroups);
                                    print(unselectedGroups);
                                  });
                                },
                              );
                            }).toList(),
                          );
                        }).toList(),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.pushNamed(context, '/view_timetable');
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
  }

  WoltModalSheetPage page1(
      BuildContext modalSheetContext, TextTheme textTheme) {
    var marinerBase = MarinerBase(
        session: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
        program: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedProgram!);
    // void setProvider() async {
    //   await marinerBase.getTimetable().then((value) {
    //     // String timetableJson = snapshot.data as String;

    //     Iterable l = jsonDecode(value);
    //     List<MarineSchedule> entries = List<MarineSchedule>.from(
    //         l.map((model) => MarineSchedule.fromJson(model)));
    //     Provider.of<NewTimetableProvider>(context, listen: false)
    //         .setEntries(entries);
    //     print(
    //         Provider.of<NewTimetableProvider>(context, listen: false).entries);
    //   });
    // }

    // setProvider();

    return WoltModalSheetPage(
      navBarHeight: 56,
      topBarTitle: Text('Please Choose', style: textTheme.titleSmall),
      isTopBarLayerAlwaysVisible: true,
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.close),
        onPressed: Navigator.of(modalSheetContext).pop,
      ),
      pageTitle: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Choose Your Current Year of Studies',
          // style: textTheme.headline6,
        ),
      ),
      child: FutureBuilder(
        future: marinerBase.getTimetable(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            String timetableJson = snapshot.data as String;
            Iterable l = jsonDecode(timetableJson);
            List<MarineSchedule> entries = List<MarineSchedule>.from(
                l.map((model) => MarineSchedule.fromJson(model)));
            // Provider.of<NewTimetableProvider>(context, listen: false)
            //     .setEntries(entries);
            // print(Provider.of<NewTimetableProvider>(context, listen: false)
            //     .entries);
            List<String> tahunList =
                entries.map((entry) => entry.tahun).toSet().toList();
            return AnimatedPadding(
              padding: MediaQuery.of(context).viewInsets,
              duration: const Duration(milliseconds: 100),
              curve: Curves.decelerate,
              child: SizedBox(
                height: 350,
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Tahun',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: tahunList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(tahunList[index]),
                            onTap: () {
                              Provider.of<NewTimetableProvider>(context,
                                      listen: false)
                                  .setSelectedYear(tahunList[index]);
                              WoltModalSheet.show(
                                pageIndexNotifier: pageIndexNotifier,
                                context: context,
                                pageListBuilder: (modalSheetContext) {
                                  final textTheme = Theme.of(context).textTheme;
                                  return [
                                    // page1(modalSheetContext, textTheme),
                                    page2(
                                        modalSheetContext, textTheme, entries),
                                    page3(modalSheetContext, textTheme),
                                  ];
                                },
                                modalTypeBuilder: (context) {
                                  return WoltModalType.dialog;
                                },
                                // useSafeArea: true,
                                // (context) {
                                //   final size =
                                //       MediaQuery.of(context).size.width;
                                //   if (size < 768.0) {
                                //     return WoltModalType.bottomSheet;
                                //   } else {
                                //     return WoltModalType.dialog;
                                //   }
                                // },
                                onModalDismissedWithBarrierTap: () {
                                  debugPrint(
                                      'Closed modal sheet with barrier tap');
                                  Navigator.of(context).pop();
                                  pageIndexNotifier.value = 0;
                                },
                                maxDialogWidth: 560,
                                minDialogWidth: 300,
                                minPageHeight: 0.0,
                                maxPageHeight: 0.9,
                              );
                              // page2(modalSheetContext, textTheme, entries);
                              // pageIndexNotifier.value += 1;
                              // showDuplicateDialog(entries);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Text('Error');
          }
          return const SizedBox(
            height: 200,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: Column(
      //     children: [
      //       Text('Hello From Page 1'),
      //       ElevatedButton(
      //         onPressed: () {
      //           pageIndexNotifier.value += 1;
      //         },
      //         style: ElevatedButton.styleFrom(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(8),
      //           ),
      //         ),
      //         child: SizedBox(
      //           height: 20,
      //           width: double.infinity,
      //           child: AnimatedSwitcher(
      //             duration: const Duration(milliseconds: 250),
      //             child: Text('Go to Page 2'),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  WoltModalSheetPage page2(BuildContext modalSheetContext, TextTheme textTheme,
      List<MarineSchedule> entries) {
    // List<MarineSchedule>? entries;
    // entries =
    //     Provider.of<NewTimetableProvider>(context, listen: false).tempEntries!;
    var year =
        Provider.of<NewTimetableProvider>(context, listen: false).selectedYear;
    List<String> courses = entries
        .where((entry) => entry.tahun == year && entry.elektif == false)
        .map((entry) => entry.course)
        .toSet()
        .toList();
    Map<String, List<String>> groupsByCourse = {};
    for (String course in courses) {
      List<String> groups = entries
          .where((entry) => entry.course == course)
          .map((entry) => entry.group)
          .toSet()
          .toList();
      groupsByCourse[course] = groups;
    }
    List<dynamic> coursesWithMultipleGroups = [];
    for (String course in groupsByCourse.keys) {
      if (groupsByCourse[course]!.length > 1) {
        coursesWithMultipleGroups.add(course);
      }
    }

    for (String course in coursesWithMultipleGroups) {
      selectedGroups[course] =
          null; // Initially, no group is selected for each course
      unselectedGroups[course] = null;
    }
    var woltModalSheetPage = WoltModalSheetPage(
      pageTitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Choose Your Group for Program(s) Down Below',
          // style: textTheme.headline6,
        ),
      ),
      child: StatefulBuilder(
        // Use StatefulBuilder to update the state of the dialog
        builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ListBody(
                    children: coursesWithMultipleGroups.map((course) {
                      return ExpansionTile(
                        // Use ExpansionTile to show the groups when the course is tapped
                        title: Text(course),
                        children: groupsByCourse[course]!.map((group) {
                          return RadioListTile.adaptive(
                            title: Text(group),
                            value: group,
                            groupValue: selectedGroups[course],
                            onChanged: (String? value) {
                              setState(() {
                                selectedGroups[course] = value;
                                print(selectedGroups[course]);

                                unselectedGroups[course] =
                                    groupsByCourse[course]
                                        ?.where((group) => group != value)
                                        .toList()
                                        .join(', ');
                                Provider.of<NewTimetableProvider>(context,
                                        listen: false)
                                    .setUnselectedGroup(unselectedGroups);
                                print(unselectedGroups);
                                canProceed = selectedGroups.values
                                    .every((value) => value != null);
                              });
                            },
                          );
                        }).toList(),
                      );
                    }).toList(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (canProceed) {
                        pageIndexNotifier.value += 1;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Please select all options before proceeding.'),
                          ),
                        );
                      }
                    },
                    child: SizedBox(
                      height: 20,
                      width: double.infinity,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: Text('Next'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      // Column(
      //   children: [
      //     Text('Hello From Page 2'),
      //     ElevatedButton(
      //       onPressed: () {
      //         pageIndexNotifier.value -= 1;
      //       },
      //       child: const Text('Go Back'),
      //     ),
      //   ],
      // ),
      leadingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
      ),
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(modalSheetContext).pop();
          pageIndexNotifier.value = 0;
        },
      ),
    );
    return coursesWithMultipleGroups.isEmpty
        ? page3(modalSheetContext, textTheme)
        :
        // return
        woltModalSheetPage;
  }

  WoltModalSheetPage page3(
      BuildContext modalSheetContext, TextTheme textTheme) {
    TextEditingController _timetableNameController = TextEditingController();
    return WoltModalSheetPage(
      pageTitle: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          'Give Your Timetable a Name',
          // style: textTheme.headline6,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _timetableNameController,
              decoration: InputDecoration(
                hintText: 'Enter your timetable name',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.of(modalSheetContext).pop();
                if (_timetableNameController.text.isNotEmpty) {
                  Provider.of<NewTimetableProvider>(context, listen: false)
                      .setTimetableName(_timetableNameController.text);
                  Navigator.pushNamed(context, '/view_timetable');
                } else {
                  return;
                }
              },
              child: SizedBox(
                height: 20,
                width: double.infinity,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: Text('Generate Timetable'),
                ),
              ),
            ),
          ],
        ),
      ),
      leadingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => pageIndexNotifier.value = pageIndexNotifier.value - 1,
      ),
      trailingNavBarWidget: IconButton(
        padding: const EdgeInsets.all(8),
        icon: const Icon(Icons.close),
        onPressed: () {
          Navigator.of(modalSheetContext).pop();
          pageIndexNotifier.value = 0;
        },
      ),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

WoltModalSheetPage studyYearPage(BuildContext modalSheetContext,
    TextTheme textTheme, ValueNotifier<int> pageIndexNotifier) {
  var marinerBase = MarinerBase(
      session:
          Provider.of<NewTimetableProvider>(modalSheetContext, listen: false)
              .selectedSession!,
      program:
          Provider.of<NewTimetableProvider>(modalSheetContext, listen: false)
              .selectedProgram!);

  return WoltModalSheetPage(
    navBarHeight: 56,
    topBarTitle: Text('Please Choose', style: textTheme.titleSmall),
    isTopBarLayerAlwaysVisible: true,
    trailingNavBarWidget: IconButton(
      padding: const EdgeInsets.all(8),
      icon: const Icon(Icons.close),
      onPressed: Navigator.of(modalSheetContext).pop,
    ),
    pageTitle: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        'Choose Your Current Year of Studies',
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
                                  duplicateCourseModal(modalSheetContext,
                                      textTheme, entries, pageIndexNotifier),
                                  timetableNameModal(modalSheetContext,
                                      textTheme, pageIndexNotifier),
                                ];
                              },
                              modalTypeBuilder: (context) {
                                return WoltModalType.dialog;
                              },
                              onModalDismissedWithBarrierTap: () {
                                Navigator.of(context).pop();
                                pageIndexNotifier.value = 0;
                              },
                              maxDialogWidth: 560,
                              minDialogWidth: 300,
                              minPageHeight: 0.0,
                              maxPageHeight: 0.9,
                            );
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
  );
}

WoltModalSheetPage duplicateCourseModal(
    BuildContext modalSheetContext,
    TextTheme textTheme,
    List<MarineSchedule> entries,
    ValueNotifier<int> pageIndexNotifier) {
  bool canProceed = false;

  Map<String, String?> selectedGroups = {};
  Map<String, String?> unselectedGroups = {};
  var year = Provider.of<NewTimetableProvider>(modalSheetContext, listen: false)
      .selectedYear;
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
    pageTitle: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
                        return RadioListTile(
                          title: Text(group),
                          value: group,
                          groupValue: selectedGroups[course],
                          onChanged: (String? value) {
                            setState(() {
                              selectedGroups[course] = value;

                              unselectedGroups[course] = groupsByCourse[course]
                                  ?.where((group) => group != value)
                                  .toList()
                                  .join(', ');
                              Provider.of<NewTimetableProvider>(context,
                                      listen: false)
                                  .setUnselectedGroup(unselectedGroups);
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
                        const SnackBar(
                          content: Text(
                              'Please select all options before proceeding.'),
                        ),
                      );
                    }
                  },
                  child: const SizedBox(
                    height: 20,
                    width: double.infinity,
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 250),
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
      ? timetableNameModal(modalSheetContext, textTheme, pageIndexNotifier)
      : woltModalSheetPage;
}

WoltModalSheetPage timetableNameModal(BuildContext modalSheetContext,
    TextTheme textTheme, ValueNotifier<int> pageIndexNotifier) {
  TextEditingController timetableNameController = TextEditingController();
  return WoltModalSheetPage(
    pageTitle: const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        'Give Your Timetable a Name',
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: timetableNameController,
            decoration: const InputDecoration(
              hintText: 'Enter your timetable name',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (timetableNameController.text.isNotEmpty) {
                Provider.of<NewTimetableProvider>(modalSheetContext,
                        listen: false)
                    .setTimetableName(timetableNameController.text);
                Navigator.pushNamed(modalSheetContext, '/view_timetable');
              } else {
                return;
              }
            },
            child: const SizedBox(
              height: 20,
              width: double.infinity,
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 250),
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

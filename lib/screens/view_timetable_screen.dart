import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umt_timetable/providers/new_timetable_provider.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  late final Future<List<LaneEvents>> timetableEvents;
  MarineSchedule? marineSchedule;
  late final newEntriesJson;

  Future<List<LaneEvents>> fetchTimetableEvents() async {
    // Initialize MarinerBase and fetch data
    var marinerBase = MarinerBase(
        session: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
        program: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedProgram!);

    // Fetch the timetable JSON
    String year =
        Provider.of<NewTimetableProvider>(context, listen: false).selectedYear!;
    String timetableJson = await marinerBase.getTimetable();

    Iterable l = jsonDecode(timetableJson);
    List<MarineSchedule> entries = List<MarineSchedule>.from(
        l.map((model) => MarineSchedule.fromJson(model)));
    var unselectedGroups =
        Provider.of<NewTimetableProvider>(context, listen: false)
            .unselectedGroup;
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

    Map<String, String> dayAbbreviations = {
      'AHAD': 'Sun',
      'ISNIN': 'Mon',
      'SELASA': 'Tue',
      'RABU': 'Wed',
      'KHAMIS': 'Thu',
      'JUMAAT': 'Fri',
      'SABTU': 'Sat',
    };

    List<LaneEvents> events = [];
    var newEntries = entries
        .where((entry) => entry.tahun == year && entry.elektif == false)
        .toList();
    newEntries
        .removeWhere((entry) => unselectedGroups![entry.course] == entry.group);
    // unselectedGroups!.containsValue(entry.group) &&
    // unselectedGroups.containsKey(entry.group));
    // print(entries);
    Set<int> generatedColors = <int>{};

    Color generateUniqueColor() {
      int colorValue;
      do {
        colorValue = Random().nextInt(0xFFFFFF);
      } while (generatedColors.contains(colorValue));
      generatedColors.add(colorValue);
      return Color(0xFF000000 + colorValue);
    }

    Color textColor(Color backgroundColor) {
      double brightness = (backgroundColor.red * 299 +
              backgroundColor.green * 587 +
              backgroundColor.blue * 114) /
          255000;
      return brightness > 0.5 ? Colors.black : Colors.white;
    }

    newEntriesJson = jsonEncode(newEntries.map((e) => e.toJson()).toList());

    print(newEntries);
    for (var entry in newEntries) {
      String dayAbbreviation = dayAbbreviations[entry.hari] ?? entry.hari;
      if (events.isEmpty || events.last.lane.name != dayAbbreviation) {
        events.add(
          LaneEvents(
            lane: Lane(
              name: dayAbbreviation,
              textStyle: TextStyle(
                fontFamily: 'Inter',
              ),
              // entry.hari
            ),
            events: [],
          ),
        );
      }
      Color backgroundColor = generateUniqueColor();
      Color foregroundColor = textColor(backgroundColor);
      events.last.events.add(
        TableEvent(
          // padding: const EdgeInsets.all(8),
          // margin: const EdgeInsets.all(4),
          backgroundColor: backgroundColor,
          textStyle: TextStyle(
            fontSize: 9,
            color: foregroundColor,
          ),
          title: entry.course,
          start: TableEventTime(
            hour: entry.startTime,
            minute: 0,
          ),
          end: TableEventTime(
            hour: entry.endTime,
            minute: 0,
          ),
          subtitle: entry.location,
        ),
      );
    }
    print(events);
    return events;
  }

  @override
  Widget build(BuildContext context) {
    // List<LaneEvents> savedTimetables = [];
    TimetableView timetableView;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          Provider.of<NewTimetableProvider>(context, listen: false)
              .timetableName!
              .toUpperCase(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 30,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.tune,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchTimetableEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<LaneEvents> newTimetables = snapshot.data as List<LaneEvents>;
            // setState(() {
            //   savedTimetables = [...savedTimetables, ...newTimetables];
            // });
            return LayoutBuilder(
              builder: (context, constraints) {
                timetableView = TimetableView(
                  timetableStyle: TimetableStyle(
                    startHour: 8,
                    endHour: 20,
                    // laneWidth: 80,
                    laneWidth:
                        constraints.maxWidth / (newTimetables.length + .8),
                    laneHeight: 30,
                    timeItemTextColor: Colors.black,
                    timeItemWidth: 40,
                  ),
                  laneEventsList: newTimetables,
                );
                return timetableView;
              },
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // print(newEntriesJson);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString(
              'timetable_' +
                  Provider.of<NewTimetableProvider>(context, listen: false)
                      .timetableName!,
              newEntriesJson);
          Navigator.pushNamed(context, '/home');
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

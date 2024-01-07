/* 
This file is a copy from lib/views/screens/view_timetable_screen.dart
with some modifications to make it work with the saved timetable.
*/

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';

class SavedTimetableScreen extends StatefulWidget {
  final dynamic newEntries;
  const SavedTimetableScreen({super.key, required this.newEntries});

  @override
  State<SavedTimetableScreen> createState() => _SavedTimetableScreenState();
}

class _SavedTimetableScreenState extends State<SavedTimetableScreen> {
  MarineSchedule? marineSchedule;

  Future<List<LaneEvents>> fetchTimetableEvents() async {
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

    List<MarineSchedule> marineSchedules = widget.newEntries.value;
    for (var marineSchedule in marineSchedules) {
      String dayAbbreviation =
          dayAbbreviations[marineSchedule.hari] ?? marineSchedule.hari;
      if (events.isEmpty || events.last.lane.name != dayAbbreviation) {
        events.add(
          LaneEvents(
            lane: Lane(
              name: dayAbbreviation,
              textStyle: const TextStyle(
                fontFamily: 'Inter',
              ),
            ),
            events: [],
          ),
        );
      }
      Color backgroundColor = generateUniqueColor();
      Color foregroundColor = textColor(backgroundColor);
      events.last.events.add(
        TableEvent(
          backgroundColor: backgroundColor,
          textStyle: TextStyle(
            fontSize: 9,
            color: foregroundColor,
          ),
          title: marineSchedule.course,
          start: TableEventTime(
            hour: marineSchedule.startTime,
            minute: 0,
          ),
          end: TableEventTime(
            hour: marineSchedule.endTime,
            minute: 0,
          ),
          subtitle: marineSchedule.location,
        ),
      );
    }
    return events;
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    TimetableView timetableView;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.newEntries.key.split('_')[1].toUpperCase()}',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.3,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black54 : Colors.white,
        elevation: 0,
        toolbarHeight: 30,
      ),
      body: FutureBuilder(
        future: fetchTimetableEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<LaneEvents> newTimetables = snapshot.data as List<LaneEvents>;
            return LayoutBuilder(
              builder: (context, constraints) {
                timetableView = TimetableView(
                  timetableStyle: TimetableStyle(
                    startHour: 8,
                    endHour: 20,
                    laneWidth:
                        constraints.maxWidth / (newTimetables.length + .8),
                    laneHeight: 30,
                    timeItemTextColor: isDarkMode ? Colors.white : Colors.black,
                    timeItemWidth: 40,
                    mainBackgroundColor:
                        isDarkMode ? Colors.black54 : Colors.white,
                    timelineBorderColor:
                        isDarkMode ? Colors.white : Colors.black,
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
        onPressed: () {
          Navigator.pushNamed(context, '/home');
        },
        child: const Icon(Icons.home),
      ),
    );
  }
}

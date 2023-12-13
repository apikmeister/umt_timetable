import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:provider/provider.dart';
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

  // @override
  // void initState() {
  //   super.initState();
  //   timetableEvents = fetchTimetableEvents();
  // }

  Future<List<LaneEvents>> fetchTimetableEvents() async {
    // Initialize MarinerBase and fetch data
    var marinerBase = MarinerBase(
        session: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedSession!,
        program: Provider.of<NewTimetableProvider>(context, listen: false)
            .selectedProgram!);

    // Fetch the timetable JSON
    String timetableJson = await marinerBase.getTimetable('lmao');

    Iterable l = jsonDecode(timetableJson);
    List<MarineSchedule> entries = List<MarineSchedule>.from(
        l.map((model) => MarineSchedule.fromJson(model)));

    // Convert JSON to a list of TableEvent objects
    // Adjust this part based on your actual data structure and requirements
    // List<LaneEvents> events = [
    //   for (var entry in entries
    //       .where((entry) => entry.tahun == "3" && entry.elektif == false))

    //     LaneEvents(lane: Lane(name: entry.hari), events: [
    //       TableEvent(
    //         title: entry.course,
    //         start: TableEventTime(
    //           hour: entry.startTime,
    //           minute: 0,
    //         ),
    //         end: TableEventTime(
    //           hour: entry.endTime,
    //           minute: 0,
    //         ),
    //         subtitle: entry.location,
    //       ),
    //     ]),
    // ];

    List<LaneEvents> events = [];

    for (var entry in entries
        .where((entry) => entry.tahun == "3" && entry.elektif == false)) {
      if (events.isEmpty || events.last.lane.name != entry.hari) {
        events.add(LaneEvents(lane: Lane(name: entry.hari), events: []));
      }
      events.last.events.add(
        TableEvent(
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
    return events;
    // ... convert the JSON data to TableEvent objects ...

    // return events;
  }

  @override
  Widget build(BuildContext context) {
    // List<TimetableView> savedTimetables = [];
    List<LaneEvents> savedTimetables = [];

    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: fetchTimetableEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<LaneEvents> newTimetables =
                  snapshot.data as List<LaneEvents>;
              // setState(() {
              //   savedTimetables = [...savedTimetables, ...newTimetables];
              // });
              return TimetableView(
                timetableStyle: const TimetableStyle(
                  startHour: 8,
                  endHour: 20,
                  laneWidth: 100,
                  laneHeight: 50,
                  timeItemTextColor: Colors.black,
                ),
                laneEventsList: newTimetables,
              );
              // return TimetableView(
              //     timetableStyle: const TimetableStyle(
              //       startHour: 8,
              //       endHour: 20,
              //       laneWidth: 100,
              //       laneHeight: 50,
              //       timeItemTextColor: Colors.black,
              //     ),
              //     laneEventsList: snapshot.data != null
              //         ? [...snapshot.data as List<LaneEvents>]
              //         : []);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

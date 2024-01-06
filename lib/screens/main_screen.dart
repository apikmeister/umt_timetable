import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:umt_timetable/screens/saved_view_timetable_screen.dart';
import 'package:umt_timetable_parser/umt_timetable_parser.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final List<LaneEvents> timetableEvents;
  bool hasTimetable = false;
  List<String> timetableList = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  Future<Map<String, List<MarineSchedule>>> getTimetableList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, List<MarineSchedule>> savedTimetables = {};
    prefs.getKeys().forEach((key) {
      if (key.startsWith('timetable_')) {
        String? timetableJson = prefs.getString(key);
        if (timetableJson != null) {
          // hasTimetable = true;
          List<MarineSchedule> timetable = (jsonDecode(timetableJson) as List)
              .map((e) => MarineSchedule.fromJson(e))
              .toList();
          savedTimetables[key] = timetable;
        }
      }
    });
    // await prefs.clear(); //FIXME:
    return savedTimetables;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getTimetableList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,\nGet Started!',
                style: GoogleFonts.inter(
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Create New Timetable'),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/create_timetable');
                          },
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                    // Spacer(),
                    Expanded(
                      child: FutureBuilder(
                        future: getTimetableList(),
                        builder: (BuildContext context,
                            AsyncSnapshot<Map<String, List<MarineSchedule>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            print(snapshot.data);
                            hasTimetable = snapshot.data!.isNotEmpty;
                            return hasTimetable
                                ? ListView.builder(
                                    itemCount: snapshot.data!.keys.length,
                                    itemBuilder: (context, index) {
                                      String key =
                                          snapshot.data!.keys.elementAt(index);
                                      return ListTile(
                                        title: Text(key.split('_')[1]),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SavedTimetableScreen(
                                                newEntries: snapshot
                                                    .data!.entries
                                                    .elementAt(index),
                                              ),
                                            ),
                                          );
                                          // Handle tap event, e.g. navigate to timetable details page
                                        },
                                        trailing: Icon(Icons.arrow_forward_ios),
                                      );
                                    },
                                  )
                                : _buildNoTimetable();
                          }
                        },
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                // hasTimetable ? _buildTimetable() : _buildNoTimetable(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimetable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Timetable'),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_timetable');
              },
              icon: const Icon(Icons.add, size: 20),
            ),
          ],
        ),
        const Spacer(),
        Center(
          child: FutureBuilder(
            future: getTimetableList(),
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, List<MarineSchedule>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.keys.length,
                  itemBuilder: (context, index) {
                    String key = snapshot.data!.keys.elementAt(index);
                    return ListTile(
                      title: Text(key),
                      onTap: () {
                        // Handle tap event, e.g. navigate to timetable details page
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildNoTimetable() {
    return Center(
      child: Column(
        children: [
          Expanded(
            child: Lottie.asset(
              'assets/lottie/notFoundAnim.json',
              animate: false,
            ),
          ),
          Text(
            'No timetable found',
            style: GoogleFonts.inter(
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

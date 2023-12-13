import 'package:flutter/material.dart';
import 'package:flutter_timetable_view/flutter_timetable_view.dart';
import 'package:google_fonts/google_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     'Timetable',
      //     style: TextStyle(
      //       color: Colors.black,
      //       fontWeight: FontWeight.bold,
      //       letterSpacing: 1.3,
      //     ),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   // leading: IconButton(
      //   //   onPressed: () {
      //   //     Navigator.pop(context);
      //   //   },
      //   //   icon: const Icon(
      //   //     Icons.arrow_back,
      //   //     color: Colors.black,
      //   //   ),
      //   // ),
      //   actions: <Widget>[
      //     IconButton(
      //       onPressed: () {},
      //       icon: const RotatedBox(
      //         quarterTurns: 1,
      //         child: Icon(
      //           Icons.tune,
      //           color: Colors.black,
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome,\nGet Started!',
                style: GoogleFonts.inter(
                  // textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 45,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
              // const SizedBox(height: 20),
              Expanded(
                child: hasTimetable ? _buildTimetable() : _buildNoTimetable(),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     setState(() {
      //       hasTimetable = !hasTimetable;
      //     });
      //   },
      //   child: const Icon(Icons.add),
      // ),
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
            Text('Timetable'),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_timetable');
              },
              icon: Icon(Icons.add, size: 20),
            ),
          ],
        ),
        Spacer(),
        Center(
          child: ListView.builder(
            itemCount: timetableList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(timetableList[index]),
              );
            },
          ),
        ),
        Spacer(),
      ],
    );
    // return Container(
    //   child: ListView.builder(
    //     itemCount: timetableList.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text(timetableList[index]),
    //       );
    //     },
    //   ),
    // );
    // return ListView.builder(
    //   itemCount: timetableEvents.length,
    //   itemBuilder: (context, index) {
    //     return ListTile(
    //       title:
    //           Text(timetableEvents[index].name), // Replace with actual property
    //     );
    //   },
    // );
  }

  Widget _buildNoTimetable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Create New Timetable'),
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/create_timetable');
              },
              icon: Icon(Icons.add, size: 20),
            ),
          ],
        ),
        Spacer(),
        Center(
          child: Column(
            children: [
              Text('No timetable found'),
            ],
          ),
        ),
        Spacer(),
      ],
    );
  }
}

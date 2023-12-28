import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

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
                child: hasTimetable ? _buildTimetable() : _buildNoTimetable(),
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
          child: ListView.builder(
            itemCount: timetableList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(timetableList[index]),
              );
            },
          ),
        ),
        const Spacer(),
      ],
    );
  }

  Widget _buildNoTimetable() {
    return Column(
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
        Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/notFoundAnim.json',
                animate: false,
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
        ),
        const Spacer(),
      ],
    );
  }
}

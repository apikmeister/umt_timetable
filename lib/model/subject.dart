import 'package:flutter/material.dart';

class Subject {
  final String name;
  final String day;
  final DateTime startTime;
  final DateTime endTime;
  final Color color;

  Subject({
    required this.name,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.color,
  });
}

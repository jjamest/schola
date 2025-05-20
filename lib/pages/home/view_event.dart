import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class TimePill extends StatelessWidget {
  final String startTime;
  final String endTime;

  const TimePill({super.key, required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade100, Colors.blue.shade200],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$startTime - $endTime',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.blue.shade900,
        ),
      ),
    );
  }
}

class ViewEventPage extends StatefulWidget {
  final Map<String, String> event;

  const ViewEventPage({super.key, required this.event});

  @override
  State<ViewEventPage> createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {
  DateTime toDateTime(String dateTimeString) {
    return DateFormat("hh:mm a").parse(dateTimeString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  widget.event['summary']!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TimePill(
                  startTime: widget.event['startTime']!,
                  endTime: widget.event['endTime']!,
                ),
                const SizedBox(height: 13),
                Text(
                  widget.event['description']!,
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

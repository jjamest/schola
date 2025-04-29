import 'package:schola/barrel.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ICalendarParser {
  final String webcalUrl;

  ICalendarParser({required this.webcalUrl});

  /// Fetches and returns a list of events for the specified date.
  /// Each event is a Map with keys: SUMMARY, DTSTART, DESCRIPTION.
  Future<List<Map<String, String>>> getTodayEvents({
    required DateTime date,
  }) async {
    try {
      // Replace webcal:// with https://
      final url = webcalUrl.replaceFirst('webcal://', 'https://');

      // Fetch the .ics file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch calendar: ${response.statusCode}');
      }

      // Parse the iCalendar data
      final events = _parseICalendar(response.body);

      // Define the start and end of the selected date
      final dateStart = DateTime(date.year, date.month, date.day);
      final dateEnd = dateStart.add(const Duration(days: 1));

      // Filter events for the selected date
      final dateEvents =
          events.where((event) {
            final startDateStr = event['DTSTART'];
            if (startDateStr == null) return false;

            try {
              DateTime startDate;
              if (startDateStr.contains('T')) {
                // Timed event
                startDate = DateTime.parse(startDateStr.replaceAll('Z', ''));
              } else {
                // All-day event
                startDate = DateFormat('yyyyMMdd').parse(startDateStr);
              }
              return startDate.isAfter(dateStart) &&
                  startDate.isBefore(dateEnd);
            } catch (e) {
              return false;
            }
          }).toList();

      return dateEvents;
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  /// Parses the iCalendar data and returns a list of events.
  List<Map<String, String>> _parseICalendar(String icsData) {
    final lines = icsData.split('\n');
    List<Map<String, String>> events = [];
    Map<String, String>? currentEvent;

    for (var line in lines) {
      line = line.trim();
      if (line == 'BEGIN:VEVENT') {
        currentEvent = {};
      } else if (line == 'END:VEVENT' && currentEvent != null) {
        events.add(currentEvent);
        currentEvent = null;
      } else if (currentEvent != null && line.contains(':')) {
        final parts = line.split(':');
        final key =
            parts[0].split(';')[0]; // Ignore parameters like DTSTART;VALUE=DATE
        final value = parts.sublist(1).join(':');
        currentEvent[key] = value;
      }
    }

    return events;
  }
}

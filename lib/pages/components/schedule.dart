import 'package:flutter/material.dart';
import 'package:schola/barrel.dart';

class ScheduleWidget extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleWidget({super.key, required this.selectedDate});

  @override
  State<ScheduleWidget> createState() => _ScheduleWidgetState();
}

class _ScheduleWidgetState extends State<ScheduleWidget> {
  bool isLoading = false;
  bool webcalSet = true;
  List<Map<String, String>> todayEvents = [];
  String statusMessage = '';
  late User userModel;
  String? lastWebcalUrl;
  StreamSubscription? _userSubscription;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(ScheduleWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      fetchTodayEvents(widget.selectedDate);
    }
  }

  Future<void> _initialize() async {
    try {
      userModel = await Util.getUserModel();
      lastWebcalUrl = userModel.scheduleURL;
      await fetchTodayEvents(widget.selectedDate);
      _startUserObservation();
    } catch (e) {
      setState(() {
        statusMessage = 'Error: $e';
        isLoading = false;
      });
      Log.e('Error fetching user model: $e');
    }
  }

  void _startUserObservation() {
    _userSubscription = Amplify.DataStore.observe(User.classType).listen(
      (event) {
        final updatedUser = event.item;
        if (updatedUser.id == userModel.id &&
            updatedUser.scheduleURL != lastWebcalUrl) {
          setState(() {
            userModel = updatedUser;
            lastWebcalUrl = updatedUser.scheduleURL;
          });
          fetchTodayEvents(widget.selectedDate);
        }
      },
      onError: (e) {
        Log.e('Error observing User model: $e');
      },
    );
  }

  Future<void> fetchTodayEvents(DateTime date) async {
    setState(() {
      isLoading = true;
      statusMessage = 'Fetching events...';
    });

    try {
      final scheduleUrl = userModel.scheduleURL?.trim() ?? '';
      if (scheduleUrl.isEmpty) {
        setState(() {
          todayEvents = [];
          statusMessage = 'Schedule not set up';
          isLoading = false;
          webcalSet = false;
        });
        return;
      }

      final parser = ICalendarParser(scheduleUrl: scheduleUrl);
      final events = await parser.getTodayEvents(date: date);

      setState(() {
        todayEvents = parser.getEventsForDate(events);
        statusMessage = todayEvents.isEmpty ? 'No events for this date.' : '';
      });
    } catch (e) {
      setState(() {
        statusMessage = 'Error: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void onEventTap(event) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ViewEventPage(event: event)),
    );
  }

  void onHelpTap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SetupWebcal()),
    );
  }

  @override
  void dispose() {
    _userSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SizedBox.shrink()
        : todayEvents.isEmpty
        ? Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statusMessage,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              if (!webcalSet)
                IconButton(icon: Icon(Icons.info), onPressed: onHelpTap),
            ],
          ),
        )
        : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayEvents.length,
          itemBuilder: (context, index) {
            final event = todayEvents[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => onEventTap(event),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        child: Text(
                          event['startTime']!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 22),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event['summary']!,
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  }
}

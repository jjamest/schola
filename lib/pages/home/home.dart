import 'package:schola/barrel.dart';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late User userModel;
  bool isLoading = true;
  bool isEventsExpanded = false;
  List<Map<String, String>> todayEvents = [];
  String statusMessage = '';
  String? lastWebcalUrl;
  StreamSubscription? _userSubscription;
  DateTime selectedDate = DateTime.now();

  Future<void> fetchTodayEvents(DateTime date) async {
    setState(() {
      isLoading = true;
      statusMessage = 'Fetching events...';
    });

    try {
      final webcalUrl = userModel.webcalURL?.trim() ?? '';
      if (webcalUrl.isEmpty) {
        setState(() {
          todayEvents = [];
          statusMessage = 'Calendar not set up';
          lastWebcalUrl = webcalUrl; // Update last known URL
          isLoading = false;
        });
        return;
      }

      final parser = ICalendarParser(webcalUrl: webcalUrl);
      final events = await parser.getTodayEvents(date: date);

      setState(() {
        todayEvents =
            events.map((event) {
              final summary = event['SUMMARY'] ?? 'No title';
              final startTime = event['DTSTART'] ?? '';
              final description = event['DESCRIPTION'] ?? 'No description';

              String formattedTime = '';
              try {
                if (startTime.contains('T')) {
                  final dateTime = DateTime.parse(
                    startTime.replaceAll('Z', ''),
                  );
                  formattedTime = DateFormat('h:mm a').format(dateTime);
                } else {
                  formattedTime = 'All day';
                }
              } catch (e) {
                formattedTime = 'Unknown time';
              }

              return {
                'summary': summary,
                'time': formattedTime,
                'description': description,
              };
            }).toList();
        statusMessage = todayEvents.isEmpty ? 'No events for this date.' : '';
        lastWebcalUrl = webcalUrl; // Update last known URL
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

  void _startUserObservation() {
    _userSubscription = Amplify.DataStore.observe(User.classType).listen(
      (event) {
        final updatedUser = event.item;
        if (updatedUser.id == userModel.id &&
            updatedUser.webcalURL != lastWebcalUrl) {
          setState(() {
            userModel = updatedUser;
          });
          fetchTodayEvents(
            selectedDate,
          ); // Refresh events when webcalURL changes
        }
      },
      onError: (e) {
        Log.e('Error observing User model: $e');
      },
    );
  }

  String getTitle() {
    final now = DateTime.now();
    final hour = now.hour;
    return hour < 12
        ? 'Good Morning'
        : hour < 17
        ? 'Good Afternoon'
        : 'Good Evening';
  }

  Future<void> _initialize() async {
    try {
      userModel = await Util.getUserModel();
      lastWebcalUrl = userModel.webcalURL;
      await fetchTodayEvents(selectedDate);
      _startUserObservation(); // Start observing User model changes
    } catch (e) {
      setState(() {
        statusMessage = 'Error: $e';
      });
      Log.e('Error fetching user model: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      await fetchTodayEvents(pickedDate);
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _userSubscription?.cancel(); // Clean up subscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('MMMM d, yyyy').format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
          child: Text(
            isLoading
                ? 'Loading...'
                : '${getTitle()}, ${userModel.displayUsername}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isEventsExpanded = !isEventsExpanded;
                            });
                          },
                          child: Text(
                            "Events for $formattedDate",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.calendar_today, size: 24),
                              onPressed: _pickDate,
                              tooltip: 'Change date',
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isEventsExpanded = !isEventsExpanded;
                                });
                              },
                              child: RotationTransition(
                                turns: AlwaysStoppedAnimation(
                                  isEventsExpanded ? 0.5 : 0.0,
                                ),
                                child: const Icon(Icons.expand_more, size: 24),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      height: isEventsExpanded ? null : 0,
                      child:
                          todayEvents.isEmpty
                              ? Center(
                                child: Text(
                                  statusMessage,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: Text(
                                              event['time']!,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  event['summary']!,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
    );
  }
}

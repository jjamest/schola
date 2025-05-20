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
  bool isEventsExpanded = true;
  DateTime selectedDate = DateTime.now();

  Future<void> _initialize() async {
    try {
      userModel = await Util.getUserModel();
    } catch (e) {
      Log.e('Error fetching user model: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    }
  }

  @override
  void initState() {
    super.initState();
    _initialize();
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
              : SingleChildScrollView(
                child: Padding(
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
                                icon: const Icon(
                                  Icons.calendar_today,
                                  size: 24,
                                ),
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
                                  child: const Icon(
                                    Icons.expand_more,
                                    size: 24,
                                  ),
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
                            isEventsExpanded
                                ? ScheduleWidget(selectedDate: selectedDate)
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

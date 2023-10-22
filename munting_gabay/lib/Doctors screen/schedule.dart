import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  late List<bool> selectedDaysList;
  late TimeOfDay openingTime;
  late TimeOfDay closingTime;
  late DateTime selectedMonth; // Add selected month
  int timeSlotGap = 30; // Time slot gap in minutes

  final TextEditingController doctorNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    selectedDaysList = List.generate(7, (index) => false);
    openingTime = TimeOfDay(hour: 8, minute: 0);
    closingTime = TimeOfDay(hour: 17, minute: 0);
    selectedMonth = DateTime.now(); // Initialize with the current month
  }

  void _showMonthPicker() async {
    DateTime? newSelectedMonth = await showDatePicker(
      context: context,
      initialDate: selectedMonth,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1), // You can adjust the range
      initialEntryMode: DatePickerEntryMode.calendar, // Choose month mode
    );

    if (newSelectedMonth != null) {
      setState(() {
        selectedMonth = newSelectedMonth;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Schedule'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: doctorNameController,
              decoration: InputDecoration(labelText: 'Doctor Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showDaysDialog();
              },
              child: Text('Select Days'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showTimePicker();
              },
              child: Text('Select Opening and Closing Times'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _setSchedule();
              },
              child: Text('Set Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDaysDialog() {
    final List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Days'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              7,
              (index) {
                final day = daysOfWeek[index];
                return CheckboxListTile(
                  title: Text(day),
                  value: selectedDaysList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      if (value != null) {
                        selectedDaysList[index] = value;
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showTimePicker() async {
    TimeOfDay? newOpeningTime = await showTimePicker(
      context: context,
      initialTime: openingTime,
    );

    if (newOpeningTime != null) {
      TimeOfDay? newClosingTime = await showTimePicker(
        context: context,
        initialTime: closingTime,
      );

      if (newClosingTime != null) {
        setState(() {
          openingTime = newOpeningTime;
          closingTime = newClosingTime;
        });
      }
    }
  }

  void _setSchedule() {
    EasyLoading.show(status: 'ADDING SCHEDULE');
    try {
      String doctorName = doctorNameController.text;
      String selectedMonthText = DateFormat.yMMMM().format(selectedMonth);

      List<String> daysOfWeek = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday'
      ];

      List<Map<String, dynamic>> availableDays = [];
      for (int i = 0; i < daysOfWeek.length; i++) {
        if (selectedDaysList[i]) {
          String day = daysOfWeek[i];
          List<String> slots = _generateTimeSlots(openingTime, closingTime);
          List<Map<String, String>> slotsWithStatus = slots.map((slot) {
            return {
              'slot': slot,
              'status': 'Available', // Set the status to "Available"
            };
          }).toList();
          availableDays.add({
            'day': day,
            'slots': slotsWithStatus,
          });
        }
      }

      // Use the current user's UID as the document name
      firestore.collection('schedule').doc(user?.email).set({
        'doctor_name': doctorName,
        'month': selectedMonthText,
        'available_days': availableDays,
      });

      // Show success message or navigate to another screen
      print('Schedule set successfully.');
    } catch (e) {
      // Handle errors
      print('Error setting schedule: $e');
    }

    // Dismiss EasyLoading after a delay
    Future.delayed(Duration(seconds: 1), () {
      EasyLoading.dismiss();
    });
  }

  List<String> _generateTimeSlots(TimeOfDay start, TimeOfDay end) {
    List<String> timeSlots = [];
    int startMinutes = start.hour * 60 + start.minute;
    int endMinutes = end.hour * 60 + end.minute;

    while (startMinutes < endMinutes) {
      int hours = startMinutes ~/ 60;
      int minutes = startMinutes % 60;

      String formattedTime =
          '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
      timeSlots.add(formattedTime);

      startMinutes += timeSlotGap;
    }

    return timeSlots;
  }

  TimeOfDay _addMinutesToTime(TimeOfDay time, int minutesToAdd) {
    int totalMinutes = time.hour * 60 + time.minute;
    totalMinutes += minutesToAdd;

    int newHour = totalMinutes ~/ 60;
    int newMinute = totalMinutes % 60;

    return TimeOfDay(hour: newHour, minute: newMinute);
  }
}


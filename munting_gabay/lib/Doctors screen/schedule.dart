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
  DateTime selectedDate = DateTime.now(); // Added selectedDate
  int timeSlotGap = 30;

  final TextEditingController doctorNameController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    selectedDaysList = List.generate(7, (index) => false);
    openingTime = TimeOfDay(hour: 8, minute: 0);
    closingTime = TimeOfDay(hour: 17, minute: 0);
  }

  Future<void> _showDatePicker() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showDatePicker(); // Added date picker
              },
              child: Text('Select Date'),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _setScheduleForYear();
              },
              child: Text('Set Schedule for Year'),
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
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
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

  void _setScheduleForYear() {
    EasyLoading.show(status: 'adding');
    print('pressed');
    try {
      String doctorName = doctorNameController.text;

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

      // Create schedules for each month of the year
      for (int month = 1; month <= 12; month++) {
        // Set the day to the 1st of the month
        DateTime currentDate = DateTime(selectedDate.year, month, 1);

        // Calculate the expiration date for the current month
        DateTime expirationDate =
            DateTime(currentDate.year, currentDate.month + 1, currentDate.day);

        // Create a map to match the selected days to the date in the selected month
        final selectedDaysWithDate = {
          'Monday': currentDate,
          'Tuesday': currentDate.add(Duration(days: 1)),
          'Wednesday': currentDate.add(Duration(days: 2)),
          'Thursday': currentDate.add(Duration(days: 3)),
          'Friday': currentDate.add(Duration(days: 4)),
          'Saturday': currentDate.add(Duration(days: 5)),
          'Sunday': currentDate.add(Duration(days: 6)),
        };

        for (int i = 0; i < daysOfWeek.length; i++) {
          if (selectedDaysList[i]) {
            String day = daysOfWeek[i];
            DateTime date = selectedDaysWithDate[day]!;
            List<String> slots = _generateTimeSlots(openingTime, closingTime);
            List<Map<String, String>> slotsWithStatus = slots.map((slot) {
              return {
                'slot': slot,
                'status': 'Available',
                'patients': '',
              };
            }).toList();
            availableDays.add({
              'day': day,
              'date': DateFormat('d MMMM').format(date),
              'slots': slotsWithStatus,
            });
          }
        }
      }

      firestore.collection('schedule').doc(user?.email).set({
        'doctor_name': doctorName,
        'available_days': availableDays,
      });
    } catch (e) {
      print('Error setting schedule: $e');
    }
    EasyLoading.dismiss();
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
}

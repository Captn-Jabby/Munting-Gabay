import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DateListScreen extends StatefulWidget {
  @override
  _DateListScreenState createState() => _DateListScreenState();
}

class _DateListScreenState extends State<DateListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late List<DateTime> allDates;
  late List<DateTime> filteredDates;
  List<String> selectedDays = [];

  @override
  void initState() {
    super.initState();
    allDates = getDatesForYear(DateTime.now().year);
    // Initially, display all the dates
    filteredDates = allDates;
  }

  List<DateTime> getDatesForYear(int year) {
    DateTime currentDate = DateTime.now();
    List<DateTime> dates = [];
    for (int month = currentDate.month; month <= 12; month++) {
      int startDay = (month == currentDate.month) ? currentDate.day : 1;
      for (int day = startDay; day <= DateTime(year, month + 1, 0).day; day++) {
        dates.add(DateTime(year, month, day));
      }
    }
    return dates;
  }

  void filterDates() {
    setState(() {
      filteredDates = allDates.where((date) {
        final dayOfWeek = DateFormat('E').format(date);
        return selectedDays.contains(dayOfWeek);
      }).toList();
    });
  }

// Function to create and save slots in Firestore with status "Available"
  void createSlotsForDate(DateTime date) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null || user.email == null) {
      print('User is not authenticated or does not have an email.');
      // Handle this case appropriately, such as showing an error message to the user.
      return;
    }

    // Define the document reference
    final documentReference = firestore.collection('schedule').doc(user.email);

    // Check if the document exists
    documentReference.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        // The document exists, update it
        List<Map<String, String>> slotsWithStatus = List.generate(18, (index) {
          final startTime = DateTime(date.year, date.month, date.day, 8, 0)
              .add(Duration(minutes: 30 * index));
          final endTime = startTime.add(Duration(minutes: 30));

          return {
            'slot':
                '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
            'status': 'Available',
            'patients': '',
          };
        });

        try {
          documentReference.update({
            'available_days': FieldValue.arrayUnion([
              {
                'day': DateFormat('E').format(date),
                'date': DateFormat('d MMMM').format(date),
                'slots': slotsWithStatus,
              }
            ]),
          });
        } catch (e) {
          print('Error updating Firestore document: $e');
          // Handle the error appropriately, such as showing an error message to the user.
        }
      } else {
        // The document doesn't exist, create it
        List<Map<String, String>> slotsWithStatus = List.generate(18, (index) {
          final startTime = DateTime(date.year, date.month, date.day, 8, 0)
              .add(Duration(minutes: 30 * index));
          final endTime = startTime.add(Duration(minutes: 30));

          return {
            'slot':
                '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
            'status': 'Available',
            'patients': '',
          };
        });

        documentReference.set({
          'available_days': [
            {
              'day': DateFormat('E').format(date),
              'date': DateFormat('d MMMM').format(date),
              'slots': slotsWithStatus,
            }
          ],
        });
      }
    }).catchError((error) {
      print('Error checking Firestore document: $error');
      // Handle the error appropriately, such as showing an error message to the user.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Yearly Dates'),
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Select days to filter: '),
            ],
          ),
          Container(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (String day in [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun'
                ])
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: FilterChip(
                      label: Text(day),
                      selected: selectedDays.contains(day),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            selectedDays.add(day);
                          } else {
                            selectedDays.remove(day);
                          }
                        });
                      },
                    ),
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              filterDates();

              // Create and save slots for filtered dates
              for (var date in filteredDates) {
                createSlotsForDate(date);
              }
            },
            child: Text('Filter and Save'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredDates.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    DateFormat('E, MMM d, y').format(filteredDates[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/Doctors%20screen/save_scheduled.dart';
import 'package:munting_gabay/variable.dart';

class DateListScreen extends StatefulWidget {
  const DateListScreen({super.key});

  @override
  _DateListScreenState createState() => _DateListScreenState();
}

class _DateListScreenState extends State<DateListScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late List<DateTime> allDates;
  late List<DateTime> filteredDates;
  List<String> selectedDays = [];
  bool hasSchedule = false; // Indicates whether a schedule has been created

  @override
  void initState() {
    super.initState();
    allDates = getDatesForYear(DateTime.now().year);
    // Initially, display all the dates
    filteredDates = allDates;
    checkIfScheduleExists(); // Check if a schedule has been created
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

  void createSlotsForDateRange(List<DateTime> dates) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User is not authenticated or does not have an email.');
      // Handle this case appropriately, such as showing an error message to the user.
      return;
    }

    final documentReference = firestore.collection('schedule').doc(user.uid);

    documentReference.get().then((docSnapshot) {
      final availableDays = dates.map((date) {
        return {
          'day': DateFormat('E').format(date),
          'date': DateFormat('d MMMM').format(date),
          'slots': List.generate(18, (index) {
            final startTime = DateTime(date.year, date.month, date.day, 8, 0)
                .add(Duration(minutes: 30 * index));
            final endTime = startTime.add(const Duration(minutes: 30));

            return {
              'slot':
                  '${DateFormat.jm().format(startTime)} - ${DateFormat.jm().format(endTime)}',
              'status': 'Available',
              'patients': '',
            };
          }),
        };
      }).toList();

      if (docSnapshot.exists) {
        // The document exists, update it
        try {
          documentReference.update({
            'available_days': FieldValue.arrayUnion(availableDays),
          });
          setState(() {
            hasSchedule = true; // Mark as having a schedule
          });
        } catch (e) {
          print('Error updating Firestore document: $e');
          // Handle the error appropriately, such as showing an error message to the user.
        }
      } else {
        // The document doesn't exist, create it
        documentReference.set({
          'available_days': availableDays,
        });
        setState(() {
          hasSchedule = true; // Mark as having a schedule
        });
      }
    }).catchError((error) {
      print('Error checking Firestore document: $error');
      // Handle the error appropriately, such as showing an error message to the user.
    });
  }

// Function to create and save slots for the entire year
  void createSlotsForYear(int year) {
    final currentDate = DateTime.now();
    final endOfYear = DateTime(year, 12, 31);

    // Generate a list of dates from the current date to the end of the year
    final dateRange = <DateTime>[];
    var currentDatePointer = currentDate;

    while (currentDatePointer.isBefore(endOfYear) ||
        currentDatePointer.isAtSameMomentAs(endOfYear)) {
      dateRange.add(currentDatePointer);
      currentDatePointer = currentDatePointer.add(const Duration(days: 1));
    }

    // Create and save slots for the range of dates
    createSlotsForDateRange(dateRange);
  }

  // Function to check if a schedule exists for the user
  void checkIfScheduleExists() {
    if (user != null && user?.uid != null) {
      final documentReference = firestore.collection('schedule').doc(user?.uid);
      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          setState(() {
            hasSchedule = true; // Mark as having a schedule
          });
        }
      });
    }
  }

  void deleteSchedule() {
    if (user != null && user?.uid != null) {
      final documentReference = firestore.collection('schedule').doc(user?.uid);

      // Check if any slot has content before deletion
      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['available_days'] != null) {
            final List<dynamic> availableDays =
                data['available_days'] as List<dynamic>;
            final hasContent = availableDays.any((day) {
              final slots = day['slots'] as List<dynamic>;
              return slots.any((slot) =>
                  slot['patients'] != null && slot['patients'].isNotEmpty);
            });

            if (hasContent) {
              EasyLoading.showToast('Cannot delete: Some slots have content',
                  toastPosition: EasyLoadingToastPosition.bottom);
            } else {
              documentReference.delete().then((_) {
                setState(() {
                  hasSchedule = false; // Mark as not having a schedule
                });
                EasyLoading.showToast('Schedule Deleted',
                    toastPosition: EasyLoadingToastPosition.bottom);
              });
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                // Color of the loading indicator
                valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                // Width of the indicator's line
                strokeWidth: 4,

                // Optional: Background color of the circle
                backgroundColor: bgloadingColor,
              ),
            ); // S; // Placeholder for loading state
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('User data not found');
          }

          bool darkMode = snapshot.data!['darkmode'] ?? false;

          bool darkmode = snapshot.data?['darkmode'] ?? false;
          Color dynamicSecondaryColor =
              darkmode ? darkSecond : DoctorsecondaryColor;
          Color dynamicScaffoldBgColor =
              darkmode ? darkPrimary : DoctorscaffoldBgColor;

          return Scaffold(
            backgroundColor: dynamicScaffoldBgColor,
            appBar: AppBar(
              backgroundColor: dynamicSecondaryColor,
              title: const Text('Yearly Dates'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkPrimary, // Change this color to the desired background color
                  ),
                  onPressed: () {
                    deleteSchedule();
                  },
                  child: const Text('Delete'),
                ),
                if (hasSchedule)
                  const Icon(
                    Icons
                        .check_circle, // Show a checkmark icon if a schedule exists
                    color: Colors.green,
                    size: 24.0,
                  ),
                IconButton(
                  icon: Icon(
                    Icons.access_time,
                    color: darkPrimary,
                  ),
                  onPressed: () {
                    // Handle the action when the message button is pressed
                    // For example, navigate to the chat screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SavedDatesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            body: Column(
              children: <Widget>[
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Select days to filter: '),
                  ],
                ),
                SizedBox(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondaryColor, // Change this color to the desired background color
                      ),
                      onPressed: () {
                        filterDates();
                      },
                      child: const Text(
                        'Filter',
                        style: TextStyle(color: text),
                      ),
                    ),
                    const SizedBox(width: 16), // Add some spacing
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: DoctorsecondaryColor, // Change this color to the desired background color
                      ),
                      onPressed: () {
                        // Create and save slots for all filtered dates
                        createSlotsForDateRange(filteredDates);
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: text),
                      ),
                    ),

                    const SizedBox(width: 16),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    key: UniqueKey(),
                    itemCount: filteredDates.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(), // Ensure each item has a unique key
                        onDismissed: (direction) {
                          // Delete the schedule when the item is dismissed
                          deleteScheduleForDate(filteredDates[index]);
                        },
                        background: Container(
                          color:
                              Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16.0), // Background color for swipe action
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: ListTile(
                          title: Text(
                            DateFormat('E, MMM d, y')
                                .format(filteredDates[index]),
                          ),
                          // Rest of your ListTile code...
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }

  void deleteScheduleForDate(DateTime date) {
    print('Deleting schedule for date: $date');
    if (user != null && user?.uid != null) {
      final documentReference = firestore.collection('schedule').doc(user?.uid);

      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data();
          if (data != null && data['available_days'] != null) {
            final List<dynamic> availableDays =
                data['available_days'] as List<dynamic>;

            // Find the index of the date to delete
            int dateIndex = availableDays.indexWhere(
              (day) => day['date'] == DateFormat('d MMMM').format(date),
            );

            if (dateIndex != -1) {
              // Remove the date from the list
              availableDays.removeAt(dateIndex);

              // Update the Firestore document with the modified list
              documentReference.update({
                'available_days': availableDays,
              }).then((_) {
                setState(() {
                  hasSchedule = false;
                  filteredDates.remove(date);
                });
                print('After deleting schedule');
                EasyLoading.showToast('Schedule Deleted',
                    toastPosition: EasyLoadingToastPosition.bottom);
              }).catchError((error) {
                // Handle errors during update
                print('Error updating Firestore document: $error');
              });
            }
          }
        }
      }).catchError((error) {
        // Handle errors during document retrieval
        print('Error retrieving Firestore document: $error');
      });
    }
  }
}

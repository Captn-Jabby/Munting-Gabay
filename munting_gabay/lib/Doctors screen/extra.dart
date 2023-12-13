import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import 'package:munting_gabay/Doctors%20screen/Dr_drawer.dart';
import 'package:munting_gabay/Doctors%20screen/newsched.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/userpage.dart';

import 'package:munting_gabay/ringtone/flutter_ringtone_player.dart';
import 'package:munting_gabay/variable.dart';
import 'package:table_calendar/table_calendar.dart';

class DocDashboard extends StatefulWidget {
  final String docId; // Doctor's ID
  User? user = FirebaseAuth.instance.currentUser; // Get the current user

  DocDashboard({required this.docId}) {
    print('Accessed DocDashboard with docId: $docId');
  }

  @override
  _DocDashboardState createState() => _DocDashboardState();
}

class _DocDashboardState extends State<DocDashboard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<DateTime, List<dynamic>> _events = {};
  late CalendarFormat _calendarFormat;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  // In _DocDashboardState
  bool previousCallStatus = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fetchPendingAndCancelledDates();
    _calendarFormat = CalendarFormat.month;
  }

  Map<String, dynamic> _getEventMarker(DateTime date) {
    final formattedDate =
        DateFormat('dd MMMM').format(date); // Use the appropriate format

    return {
      'date': formattedDate,
      'status': 'pending',
      // You can add more information to the event marker if needed
    };
  }

  // Method to update events with pending dates
// Add this field in _DocDashboardState
  Set<DateTime> pendingDateTimeSet = Set();

  void _updateEvents(List<String> pendingDates) {
    setState(() {
      _events = {}; // Clear existing events
      pendingDateTimeSet = pendingDates.map((date) {
        // Format the date from the pendingDates list to match the calendar format
        final formattedDate = DateFormat('d MMMM')
            .parse(date + ' 2023'); // Assuming the year is 2023
        return formattedDate;
      }).toSet();

      for (DateTime date in pendingDateTimeSet) {
        _events[date] = [_getEventMarker(date)];
      }
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        throw FormatException('Invalid month number: $month');
    }
  }

  void _fetchPendingAndCancelledDates() {
    FirebaseFirestore.instance
        .collection('schedule')
        .doc(widget.user?.email)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data()!;
        final List<dynamic> availableDays = data['available_days'] ?? [];

        final List<String> pendingDates = [];
        final List<String> cancelledDates = [];

        for (var day in availableDays) {
          final slots = day['slots'] as List<dynamic>;
          final pendingSlots = slots.where((slot) {
            final status = slot['status'] as String;
            return status.toLowerCase() == 'pending';
          }).toList();

          final cancelledSlots = slots.where((slot) {
            final status = slot['status'] as String;
            return status.toLowerCase() == 'cancelled';
          }).toList();

          if (pendingSlots.isNotEmpty) {
            pendingDates.add(day['date'] as String);
          }

          if (cancelledSlots.isNotEmpty) {
            cancelledDates.add(day['date'] as String);
          }
        }

        print('Pending Dates: $pendingDates');
        print('Cancelled Dates: $cancelledDates');

        _updatePendingAndCancelledEvents(pendingDates, cancelledDates);
      } else {
        print('Document does not exist for user: ${widget.user?.email}');
      }
    }).catchError((error) {
      print('Error fetching dates: $error');
    });
  }

  void _updatePendingAndCancelledEvents(
      List<String> pendingDates, List<String> cancelledDates) {
    setState(() {
      _events = {}; // Clear existing events

      final List<DateTime> pendingDateTimeSet = pendingDates.map((date) {
        final formattedDate =
            DateFormat('d MMMM').parse(date + ' 2023'); // Adjust year if needed
        return formattedDate;
      }).toList();

      final List<DateTime> cancelledDateTimeSet = cancelledDates.map((date) {
        final formattedDate =
            DateFormat('d MMMM').parse(date + ' 2023'); // Adjust year if needed
        return formattedDate;
      }).toList();

      for (DateTime date in pendingDateTimeSet) {
        _events[date] = [_getEventMarker(date)];
      }

      for (DateTime date in cancelledDateTimeSet) {
        _events[date] = [_getEventMarker(date)];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2023, 1, 1),
              lastDay: DateTime.utc(2023, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                // Handle day selection as needed
              },
              eventLoader: (day) {
                return _events[day] ?? [];
              },
              calendarStyle: const CalendarStyle(
                markersAlignment: Alignment.bottomRight,
              ),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, date, events) {
                  final formattedDate = DateFormat('d MMMM').format(date);

                  final isPending = pendingDateTimeSet.any((pendingDate) {
                    final formattedPendingDate =
                        DateFormat('d MMMM').format(pendingDate);
                    return formattedDate == formattedPendingDate;
                  });

                  // Check for cancelled status
                  final isCancelled = events?.any((event) {
                        if (event is Map<String, dynamic>) {
                          if (event['status'] == 'cancelled') {
                            print(
                                'Yellow mark for date: $formattedDate'); // Debug print for yellow mark
                            return true;
                          }
                        }
                        return false;
                      }) ??
                      false;

                  if (isPending) {
                    return Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  } else if (isCancelled) {
                    print(
                        'Cancelled date: $formattedDate'); // Debug print for cancelled date

                    return Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  }

                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

  // void _handleDateClick(List<dynamic>? events) {
  //   if (events != null && events.isNotEmpty) {
  //     final eventData = events.first as Map<String, dynamic>;
  //     // Extract the necessary information from eventData
  //     final date = eventData['date'];
  //     final status = eventData['status'];
  //     final additionalInfo = eventData['additionalInfo'];

  //     // Show a dialog or navigate to another page with the extracted information
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text('Date: $date'),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: <Widget>[
  //                 Text('Status: $status'),
  //                 Text('Additional Information: $additionalInfo'),
  //                 // Add more information widgets if needed
  //               ],
  //             ),
  //           ),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //               child: Text('Close'),
  //             ),
  //           ],
  //         );
  //       },
  //     );
  //   } else {
  //     // If no events found for the selected date
  //     print('No events found for this date.');
  //   }
  // }

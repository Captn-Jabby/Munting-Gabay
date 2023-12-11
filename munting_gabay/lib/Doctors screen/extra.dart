import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/doctor_call.dart';
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
    _fetchPendingDates();
    _calendarFormat = CalendarFormat.month;
  }

  // Method to fetch pending dates from Firebase and update events
  void _fetchPendingDates() {
    FirebaseFirestore.instance
        .collection('pending_dates') // Replace with your collection name
        .doc(widget.docId)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final Map<String, dynamic> data = snapshot.data()!;
        List<String> pendingDates = List<String>.from(data['dates'] ?? []);

        // Update events with pending dates
        _updateEvents(pendingDates);
      }
    }).catchError((error) {
      print('Error fetching pending dates: $error');
    });
  }

  // Method to update events with pending dates
  void _updateEvents(List<String> pendingDates) {
    setState(() {
      _events = {}; // Clear existing events

      // Map pending dates to DateTime objects
      List<DateTime> pendingDateTimeDates = pendingDates.map((date) {
        return DateTime.parse(date);
      }).toList();

      // Update events map
      for (DateTime date in pendingDateTimeDates) {
        _events[date] = [
          _getEventMarker(date)
        ]; // You can add more information to the event marker if needed
      }
    });
  }

  // Method to get an event marker for a date
  Map<String, dynamic> _getEventMarker(DateTime date) {
    return {
      'date': date,
      'status':
          'pending', // You can add more information to the event marker if needed
    };
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
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
              eventLoader: _getEventsForDay,
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
            ),
            // Your existing code for tabs and content goes here
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDayList('Available'),
                  _buildDayList('Pending'),
                  _buildDayList('Canceled'),
                  _buildDayList('Accepted'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build date cells with custom background color
  Widget buildDateCell(DateTime date, bool isSelected) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color:
            isSelected ? Colors.blue : null, // Change the selected date color
        borderRadius: BorderRadius.circular(8),
      ),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildDayList(String statusFilter) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('schedule')
          .doc(widget.docId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(
            child: Text('No data found for this doctor.'),
          );
        } else {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          var availableDays = data['available_days'] as List<dynamic>;

          var filteredDays = availableDays.where((day) {
            var dayData = day as Map<String, dynamic>;
            var slots = dayData['slots'] as List<dynamic>;
            return slots.any((slot) {
              var slotData = slot as Map<String, dynamic>;
              return slotData['status'] == statusFilter;
            });
          }).toList();

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Doctor Name: ${widget.docId}'),
                Text('Available Days:'),
                filteredDays.isEmpty
                    ? Center(
                        child: Text('No $statusFilter slots available.'),
                      )
                    : Column(
                        children: filteredDays.map<Widget>((day) {
                          var dayData = day as Map<String, dynamic>;
                          return DayCardDOC(
                            dayData: dayData,
                            docId: widget.docId,
                            selectedStatusFilter: statusFilter,
                          );
                        }).toList(),
                      ),
              ],
            ),
          );
        }
      },
    );
  }
}

class DayCardDOC extends StatefulWidget {
  final Map<String, dynamic> dayData;
  final String docId;
  final String selectedStatusFilter; // Add the selected status filter

  DayCardDOC(
      {required this.dayData,
      required this.docId,
      required this.selectedStatusFilter});

  @override
  _DayCardDOCState createState() => _DayCardDOCState();
}

class _DayCardDOCState extends State<DayCardDOC> {
  bool slotsVisible = false;

  @override
  Widget build(BuildContext context) {
    // Check if there are slots with the selected status
    bool hasFilteredSlots =
        (widget.dayData['slots'] as List<dynamic>).any((slot) {
      return (slot as Map<String, dynamic>)['status'] ==
          widget.selectedStatusFilter;
    });

    if (!hasFilteredSlots) {
      return SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Day: ${widget.dayData['day']}'),
            subtitle: Text('Date: ${widget.dayData['date']}'),
            trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary:
                    scaffoldBgColor, // Change this color to the desired background color
              ),
              onPressed: () {
                setState(() {
                  slotsVisible = !slotsVisible;
                });
              },
              child: Text(slotsVisible ? 'Hide Slots' : 'Show Slots'),
            ),
          ),
          if (slotsVisible)
            Column(
              children:
                  (widget.dayData['slots'] as List<dynamic>).where((slot) {
                return (slot as Map<String, dynamic>)['status'] ==
                    widget.selectedStatusFilter;
              }).map<Widget>((slot) {
                return SlotTileDOC(
                  slotData: slot as Map<String, dynamic>,
                  docId: widget.docId,
                  day: widget.dayData['day'] as String,
                  selectedStatusFilter: widget
                      .selectedStatusFilter, // Pass the selected status filter to SlotTileDOC
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class SlotTileDOC extends StatefulWidget {
  final Map<String, dynamic> slotData;
  final String docId;
  final String day;
  final String selectedStatusFilter; // Add the selected status filter

  SlotTileDOC({
    required this.slotData,
    required this.docId,
    required this.day,
    required this.selectedStatusFilter, // Add the selected status filter
  });

  @override
  _SlotTileDOCState createState() => _SlotTileDOCState();
}

class _SlotTileDOCState extends State<SlotTileDOC> {
  bool Accepting = false;

  @override
  Widget build(BuildContext context) {
    final String status = widget.slotData['status'];
    final String patientName = widget.slotData['patients'] as String;

    if (status == widget.selectedStatusFilter) {
      return ListTile(
        title: Text(' ${widget.slotData['slot']} \n Status: $status'),
        subtitle: Text('Patient: $patientName'),
        trailing: Visibility(
          visible: status !=
              'Available', // Hide the button if the status is 'Available'
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:
                  scaffoldBgColor, // Change this color to the desired background color
            ),
            onPressed: () {
              if (widget.slotData['status'] == 'Canceled') {
                // Clear the 'patients' field and set the status to 'Available'
                _cancelAppointment(
                    widget.day, widget.slotData['slot'] as String);
              } else {
                setState(() {
                  Accepting = true;
                });
                _requestAppointment(
                    widget.day, widget.slotData['slot'] as String);
              }
            },
            child: Text(
              widget.slotData['status'] == 'Canceled'
                  ? 'Set Available'
                  : Accepting
                      ? 'Accepting...'
                      : 'Accept',
            ),
          ),
        ),
      );
    } else {
      return Container(); // Do not display slots with different statuses
    }
  }

  void _cancelAppointment(String day, String timeSlot) {
    User? user = FirebaseAuth.instance.currentUser;
    print('Canceling appointment for: $day at $timeSlot');

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a reference to the day within the document
    DocumentReference dayRef =
        firestore.collection('schedule').doc(widget.docId);

    // Get the existing day data
    dayRef.get().then((daySnapshot) {
      if (mounted) {
        // Check if the widget is still mounted
        if (daySnapshot.exists) {
          Map<String, dynamic> dayData =
              daySnapshot.data() as Map<String, dynamic>;

          // Find the day with the matching 'day' field
          var selectedDay = dayData['available_days'].firstWhere(
            (dayEntry) => dayEntry['day'] == day,
            orElse: () => null,
          );

          if (selectedDay != null) {
            // Remove the 'patients' field and set the status to 'Available'
            List<dynamic> slots = List.from(selectedDay['slots']);
            int slotIndex =
                slots.indexWhere((slotEntry) => slotEntry['slot'] == timeSlot);

            if (slotIndex != -1) {
              // Clear the 'patients' field and set the status to 'Available'
              slots[slotIndex]['patients'] = '';
              slots[slotIndex]['status'] = 'Available';

              // Update the slot in the list
              dayData['available_days']
                      [dayData['available_days'].indexOf(selectedDay)]
                  ['slots'] = slots;

              // Update the Firestore document with the modified day data
              dayRef.update({
                'available_days': dayData['available_days'],
              }).then((_) {
                if (mounted) {
                  // Check if the widget is still mounted
                  print('Appointment canceled.');
                  setState(() {
                    Accepting = false;
                  });

                  // Handle success, e.g., show a confirmation message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment canceled.')),
                  );
                }
              }).catchError((error) {
                if (mounted) {
                  // Check if the widget is still mounted
                  print('Error canceling appointment: $error');
                  setState(() {
                    Accepting = false;
                  });

                  // Handle errors, e.g., show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error canceling appointment.'),
                    ),
                  );
                }
              });
            }
          }
        }
      }
    });
  }

  void _requestAppointment(String day, String timeSlot) {
    User? user = FirebaseAuth.instance.currentUser;
    print('Accepting appointment for: $day at $timeSlot');

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Create a reference to the day within the document
    DocumentReference dayRef =
        firestore.collection('schedule').doc(widget.docId);

    //sting day data
    dayRef.get().then((daySnapshot) {
      if (daySnapshot.exists) {
        Map<String, dynamic> dayData =
            daySnapshot.data() as Map<String, dynamic>;

        // Find the day with the matching 'day' field
        var selectedDay = dayData['available_days'].firstWhere(
          (dayEntry) => dayEntry['day'] == day,
          orElse: () => null,
        );

        if (selectedDay != null) {
          // Update the Firestore document directly by removing the old slot and adding the updated slot
          List<dynamic> slots = List.from(selectedDay['slots']);
          int slotIndex =
              slots.indexWhere((slotEntry) => slotEntry['slot'] == timeSlot);

          if (slotIndex != -1) {
            // Update the status and add the user's email
            slots[slotIndex]['status'] = 'Accepted';

            // Update the slot in the list
            dayData['available_days']
                    [dayData['available_days'].indexOf(selectedDay)]['slots'] =
                slots;

            // Update the Firestore document with the modified day data
            dayRef.update({
              'available_days': dayData['available_days'],
            }).then((_) {
              print('Appointment request submitted.');
              setState(() {
                Accepting = false;
              });

              // Handle success, e.g., show a confirmation message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Appointment request submitted.')),
              );
            }).catchError((error) {
              print('Error submitting appointment request: $error');
              setState(() {
                Accepting = false;
              });

              // Handle errors, e.g., show an error message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error submitting appointment request.'),
                ),
              );
            });
          }
        }
      }
    });
  }
}

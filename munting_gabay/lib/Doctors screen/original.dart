import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:munting_gabay/Doctors%20screen/Dr_drawer.dart';
import 'package:munting_gabay/Doctors%20screen/newsched.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/userpage.dart';
import 'package:munting_gabay/doctor_call.dart';
import 'package:munting_gabay/variable.dart';

import '../ringtone/event_service.dart';
import '../ringtone/flutter_ringtone_player.dart';

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

  // In _DocDashboardState
  bool previousCallStatus = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Listen to changes in callStatus
    FirebaseFirestore.instance
        .collection('usersdata') // Update with your collection name
        .doc(widget.docId)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.exists) {
        final bool newCallStatus = snapshot.data()?['callStatus'] ?? false;
        final String currentUserUid =
            snapshot.data()?['currentUserUid'] ?? ''; // Fetch currentUserUid

        if (newCallStatus != previousCallStatus && newCallStatus) {
          // Value changed from false to true, show the reject dialog
          _showRejectDialog(currentUserUid); // Pass currentUserUid
        }

        // Update previousCallStatus
        previousCallStatus = newCallStatus;

        if (newCallStatus) {
          FlutterRingtonePlayer().playAlarm(); // Activate ringtone
        } else {
          FlutterRingtonePlayer().stop(); // Stop ringtone
        }
      }
    });
  }

  // Add this method to your _DocDashboardState class
  Future<void> _showRejectDialog(String currentUserUid) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Incoming Call'),
          content: Text(
              'You have an incoming call from $currentUserUid. Do you want to answer it?'),
          actions: <Widget>[
            TextButton(
              child: Text('Reject'),
              onPressed: () async {
                // Update the callStatus field to false when rejecting the call
                await FirebaseFirestore.instance
                    .collection('usersdata') // Update with your collection name
                    .doc(widget.docId)
                    .update({'callStatus': false});

                // Close the dialog
                Navigator.of(context).pop();

                // You can add any additional logic here if needed
              },
            ),
            TextButton(
              child: Text('Answer'),
              onPressed: () async {
                // Fetch currentUserUid from Firestore
                final DocumentSnapshot<Map<String, dynamic>> docSnapshot =
                    await FirebaseFirestore.instance
                        .collection(
                            'usersdata') // Update with your collection name
                        .doc(widget.docId)
                        .get();

                if (docSnapshot.exists) {
                  final String currentUserUid =
                      docSnapshot.data()?['currentUserUid'] ?? '';

                  // Update callStatus to false
                  await FirebaseFirestore.instance
                      .collection('usersdata')
                      .doc(widget.docId)
                      .update({'callStatus': false});

                  Navigator.of(context).pop();

                  // Navigate to CallDoctor with currentUserUid
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CallDoctor(
                        currentUserUid: currentUserUid,
                        currentUserName:
                            currentUserUid, // You might want to fetch the user's name from Firestore if available
                        docId: widget.docId,
                        currentemailId: currentUserUid,
                      ),
                    ),
                  );
                } else {
                  // Handle the case where the document does not exist
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Unsubscribe or cancel any listeners or subscriptions.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Dr Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: () {
              // Handle the action when the message button is pressed
              // For example, navigate to the chat screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserSelectionPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.calendar_month,
              color: Colors.indigo,
            ),
            onPressed: () {
              // Handle the action when the calendar button is pressed
              // For example, navigate to the calendar screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DateListScreen()),
              );
            },
          ),
        ],
      ),
      drawer: DrDrawer(),
      body: DefaultTabController(
        length: 4, // Adjust the length based on the number of statuses
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: 'Available'),
                Tab(text: 'Pending'),
                Tab(text: 'Canceled'),
                Tab(text: 'Accepted'),
              ],
            ),
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

  Widget _buildDayList(String statusFilter) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('schedule')
          .doc(widget.docId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              // Color of the loading indicator
              valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

              // Width of the indicator's line
              strokeWidth: 4,

              // Optional: Background color of the circle
              backgroundColor: bgloadingColor,
            ),
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

          // Filter and display the data from Firestore based on the selected status
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
                Text('Doctor Name:  ${widget.docId}'),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/variable.dart';

class SavedDatesScreen extends StatefulWidget {
  @override
  _SavedDatesScreenState createState() => _SavedDatesScreenState();
}

class _SavedDatesScreenState extends State<SavedDatesScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> savedDatesAndSlots = [];

  @override
  void initState() {
    super.initState();
    retrieveSavedDatesAndSlots();
  }

  void retrieveSavedDatesAndSlots() {
    if (user != null && user?.email != null) {
      final documentReference =
          firestore.collection('schedule').doc(user?.email);

      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          setState(() {
            final List<dynamic> data =
                docSnapshot.data()?['available_days'] ?? [];
            savedDatesAndSlots =
                data.map((day) => Map<String, dynamic>.from(day)).toList();
          });
        }
      }).catchError((error) {
        print('Error retrieving Firestore document: $error');
      });
    }
  }

  void deleteSlot(String date, String slot) {
    if (user != null && user?.email != null) {
      final documentReference =
          firestore.collection('schedule').doc(user?.email);

      documentReference.get().then((docSnapshot) {
        if (docSnapshot.exists) {
          final List<dynamic> availableDays =
              docSnapshot.data()?['available_days'] ?? [];

          final List<Map<String, dynamic>> modifiedAvailableDays =
              List<Map<String, dynamic>>.from(availableDays);

          final index =
              modifiedAvailableDays.indexWhere((day) => day['date'] == date);

          if (index != -1) {
            final List<dynamic> slots =
                List.from(modifiedAvailableDays[index]['slots']);

            final slotIndex = slots.indexWhere((s) => s['slot'] == slot);

            if (slotIndex != -1) {
              slots.removeAt(slotIndex);
              modifiedAvailableDays[index]['slots'] = slots;

              documentReference
                  .update({'available_days': modifiedAvailableDays}).then(
                (_) {
                  setState(() {
                    savedDatesAndSlots = modifiedAvailableDays;
                  });
                },
              ).catchError((error) {
                print('Error updating Firestore document: $error');
              });
            }
          }
        }
      }).catchError((error) {
        print('Error retrieving Firestore document: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DoctorscaffoldBgColor,
      appBar: AppBar(
        backgroundColor: DoctorsecondaryColor,
        title: Text('Saved Dates and Slots'),
      ),
      body: savedDatesAndSlots.isEmpty
          ? Center(
              child: Center(
                child: CircularProgressIndicator(
                  // Color of the loading indicator
                  valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                  // Width of the indicator's line
                  strokeWidth: 4,

                  // Optional: Background color of the circle
                  backgroundColor: bgloadingColor,
                ),
              ),
            )
          : ListView.builder(
              itemCount: savedDatesAndSlots.length,
              itemBuilder: (context, index) {
                final dateData = savedDatesAndSlots[index];
                return Card(
                  child: ListTile(
                    title: Text(
                      'Date: ${dateData['date']}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (var slot in dateData['slots'])
                          Dismissible(
                            key: Key(slot['slot']), // Unique key for each slot
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.only(right: 20.0),
                              color: Colors.red,
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                            onDismissed: (direction) {
                              // Delete the slot
                              deleteSlot(
                                dateData['date'],
                                slot['slot'],
                              );
                            },
                            child: ListTile(
                              title: Text('Slot: ${slot['slot']}'),
                              subtitle: Text(
                                'Status: ${slot['status']} - Patients: ${slot['patients'] ?? 'No patients'}',
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

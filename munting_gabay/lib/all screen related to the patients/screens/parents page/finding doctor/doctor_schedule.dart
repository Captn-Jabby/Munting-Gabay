import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../models/schedule.dart';
import '../../../../providers/current_user_provider.dart';
import '../../../../providers/schedule_provider.dart';
import '../../../../variable.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  _DoctorScheduleScreenState createState() => _DoctorScheduleScreenState();
}

class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final DateTime _todate = DateTime.now()
      .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0, microsecond: 0);
  late ScheduleProvider _scheduleProvider;
  late CurrentUserProvider _currentUserProvider;
  final TextEditingController _dateCtrl = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now().replacing(minute: 0);

  // show date time picker
  void createNewRequest() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("New Request"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _dateCtrl,
                  decoration: InputDecoration(
                    hintText: "Select Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: const Icon(Icons.calendar_month),
                  ),
                  readOnly: true,
                  onTap: selectDate,
                  validator: (value) {
                    if (value == "") {
                      return "Date is required";
                    }

                    final DateTime date =
                        DateFormat("MM/dd/yyyy hh:mm a").parse(value!);
                    final DateTime start =
                        DateTime(date.year, date.month, date.day, 8);
                    final DateTime end =
                        DateTime(date.year, date.month, date.day, 16);

                    if (date.isBefore(DateTime.now())) {
                      return "Request is allowed only beyond this time";
                    }

                    if (!(date.isAfter(start) && date.isBefore(end))) {
                      return "Should between 8:00 AM - 4:00 PM";
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                final selectedDate =
                    DateFormat("MM/dd/yyyy hh:mm a").parse(_dateCtrl.text);

                final newSchedule = Schedule(
                  doctorId: _scheduleProvider.getSelectedDoctor!.id,
                  patientId: _currentUserProvider.currentUser!.id,
                  dateStart: selectedDate,
                  dateEnd: selectedDate.add(
                    const Duration(hours: 1),
                  ),
                  status: "Pending",
                );

                _scheduleProvider
                    .saveScheduleRequest(
                  context: context,
                  schedule: newSchedule,
                )
                    .then(
                  (value) {
                    if (!value) {
                      return;
                    }

                    Navigator.pop(context);
                  },
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    ).whenComplete(
      () {
        _selectedDate = DateTime.now();
        _selectedTime = TimeOfDay.now().replacing(minute: 0);
        _dateCtrl.clear();
      },
    );
  }

  void selectDate() {
    showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: _todate,
      lastDate: _todate.copyWith(
        year: _todate.year + 10,
      ),
    ).then(
      (value) {
        if (value == null) {
        } else {
          selectTime(value);
        }
      },
    );
  }

  void selectTime(DateTime date) {
    showTimePicker(
      context: context,
      initialTime: _selectedTime,
    ).then((time) {
      if (time == null) {
        return;
      }

      _selectedDate = date;
      _selectedTime = time;
      _dateCtrl.text =
          "${DateFormat("MM/dd/yyyy").format(date)} ${(time.format(context))}";
    });
  }

  @override
  void initState() {
    _scheduleProvider = Provider.of<ScheduleProvider>(context, listen: false);
    _currentUserProvider =
        Provider.of<CurrentUserProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _dateCtrl.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Request Appointment'),
        actions: [
          IconButton(
            onPressed: () {
              createNewRequest();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, provider, child) {
          final schedules = provider.getActiveDocSched;

          if (provider.isScheduleLoading) {
            return const Center(
              child: CircularProgressIndicator(
                // Color of the loading indicator
                valueColor: AlwaysStoppedAnimation<Color>(LoadingColor),

                // Width of the indicator's line
                strokeWidth: 4,

                // Optional: Background color of the circle
                backgroundColor: bgloadingColor,
              ),
            );
          }

          // Access and display the data from Firestore
          if (schedules.isEmpty) {
            return const Center(
              child: Text("No Schedule Found."),
            );
          }

          return SingleChildScrollView(
            child: Column(
              children: schedules
                  .map<Widget>(
                    (e) => Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(
                          DateFormat("MMMM dd").format(e.dateStart),
                        ),
                        subtitle: Text(
                          "${DateFormat("hh:mm a").format(e.dateStart)} - ${DateFormat("hh:mm a").format(e.dateEnd)}",
                        ),
                        trailing: Text(e.status),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
          // return ListView.builder(
          //   itemCount: _schedules.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(_schedules[index]["date"]),
          //       subtitle: Text(
          //         _schedules[index]["timeslot"].toString(),
          //       ),
          //     );
          //   },
          // );
        },
      ),
    );
  }
}

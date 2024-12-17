import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../../../providers/schedule_provider.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  _RequestListScreenState createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('My Requests'),
      ),
      body: Consumer<ScheduleProvider>(
        builder: (context, provider, child) {
          final myRequests = provider.getRequestedSchedule;

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

          if (myRequests.isEmpty) {
            return const Center(
              child: Text('You have not made any requests.'),
            );
          }

          return ListView.builder(
            itemCount: myRequests.length,
            itemBuilder: (context, index) {
              final schedule = myRequests[index];
              final slot =
                  "${DateFormat("hh:mm").format(schedule.dateStart)} - ${DateFormat("hh:mm a").format(schedule.dateEnd)}";
              final date = DateFormat("MMMM dd").format(schedule.dateStart);
              final status = schedule.status;

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: ListTile(
                  title: Text(date),
                  subtitle: Text("$slot \u2022 $status"),
                  trailing: schedule.status != "Pending"
                      ? null
                      : ElevatedButton(
                          style:
                              buttonStyle1, // Change this color to the desired background color

                          onPressed: () {
                            provider.cancelRequest(
                              context: context,
                              schedule: schedule,
                            );
                          },
                          child: const Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

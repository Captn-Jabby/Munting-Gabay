import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:munting_gabay/variable.dart';
import 'package:provider/provider.dart';

import '../providers/doctor_provider.dart';

class PhoneCallScreen extends StatelessWidget {
  const PhoneCallScreen({super.key});

  void makePhoneCall({required String phoneNumber}) async {
    bool? res = await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    if (res!) {
      print('Phone call successful');
    } else {
      print('Error making the phone call');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Make a Phone Call'),
      ),
      body: Consumer<DoctorProvider>(
        builder: (context, provider, child) {
          final doctor = provider.getSelectedDoctor!;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  foregroundImage: NetworkImage(doctor.profilePicture),
                  radius: 75,
                ),
                const SizedBox(height: 12),
                Text(
                  'Doctor Name: ${doctor.name}',
                  style: const TextStyle(fontSize: 18, color: text),
                ),
                Text(
                  'Phone Number: ${doctor.phoneNumber}',
                  style: const TextStyle(fontSize: 18, color: text),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: BtnWidth,
                  height: BtnHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          secondaryColor, // Change this color to the desired background color
                    ),
                    onPressed: () {
                      makePhoneCall(
                          phoneNumber: doctor
                              .phoneNumber); // Call the function to make a phone call
                    },
                    child: Text(
                      'Call ${doctor.phoneNumber}',
                      style: buttonTextStyle1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

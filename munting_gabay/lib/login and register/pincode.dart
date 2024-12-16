import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/login%20and%20register/forgot_pin.dart';
import 'package:munting_gabay/variable.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../providers/current_user_provider.dart';

class PinScreen extends StatefulWidget {
  const PinScreen({super.key});

  @override
  _PinScreenState createState() => _PinScreenState();
}

class _PinScreenState extends State<PinScreen> {
  String enteredPin = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text('Enter PIN'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinCodeTextField(
              appContext: context,
              length: 4, // Set the length of the PIN
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  enteredPin = value;
                });
              },
              onCompleted: (value) {
                // Called when the user completes entering the PIN
                _verifyPin(context, value); // Call the verification method
              },
            ),
            const SizedBox(height: 10.0),
            const Text(
              'Enter your PIN',
              style: TextStyle(fontSize: 18.0),
            ),
            // Inside your PinScreen widget build method:
            const SizedBox(height: 20.0),
            SizedBox(
              width: BtnWidth,
              height: BtnHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      secondaryColor, // Change this color to the desired background color
                ),
                onPressed: () {
                  // Navigate to the ForgotPINScreen when the button is pressed
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewPINScreen(),
                    ),
                  );
                },
                child: Text(
                  "Reset PIN",
                  style: buttonTextStyle1,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  // getting the Pincode in the firebase (PLEASE ALSO CHECK THE CHANGEPIN_SCREEN)
  void _verifyPin(BuildContext context, String pin) {
    EasyLoading.show(status: 'Verifying PIN...'); // Show loading indicator

    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).currentUser!;

    if (currentUser.pin != pin) {
      EasyLoading.showError('Incorrect PIN. Please try again.');

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ParentPage(),
      ),
    );

    EasyLoading.dismiss();
  }
}

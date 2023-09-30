import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/psych.dart';
import 'package:munting_gabay/variable.dart';

import '../../../drawer_page.dart';

class ParentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: scaffoldBgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: BtnColor),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "PARENT'S PAGE",
                  style: buttonTextStyle,
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
                height: 600,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    // childAspectRatio: 3.0,
                    crossAxisCount: 2, // Number of columns in the grid
                    mainAxisSpacing: 16.0, // Spacing between rows
                    crossAxisSpacing: 16.0, // Spacing between columns
                  ),
                  padding: const EdgeInsets.all(16.0),
                  itemCount: 5, // Number of buttons
                  itemBuilder: (BuildContext context, int index) {
                    return buildButton(index, context);
                  },
                )),
          ]),
        )));
  }

  Widget buildButton(int index, BuildContext context) {
    // Set button text and color based on index
    switch (index) {
      case 0:
        buttonText = 'Psychologist Research';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 1:
        buttonText = 'Educational Webinars';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 2:
        buttonText = 'Resource Library';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 3:
        buttonText = 'Online Consultation';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 4:
        buttonText = 'Forum and Discussion';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 5:
        buttonText = 'Progress Tracker';
        buttonColor = Colors.amber; // Customize the color for this button
        break;
      default:
        break;
    }

    return GridTile(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the corresponding screen when the button is pressed
            switch (index) {
              case 0:
                // Navigate to the screen for 'Psychologist Research'
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pscyh()),
                );
                break;
              case 1:
                // Navigate to the screen for 'Screen 2'
                // Replace with the actual screen navigation code
                break;
              case 2:
                // Navigate to the screen for 'Screen 3'
                // Replace with the actual screen navigation code
                break;
              case 3:
                // Navigate to the screen for 'Screen 4'
                // Replace with the actual screen navigation code
                break;
              case 4:
                // Navigate to the screen for 'Screen 5'
                // Replace with the actual screen navigation code
                break;
              case 5:
                // Navigate to the screen for 'Screen 6'
                // Replace with the actual screen navigation code
                break;
              default:
                break;
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}

String buttonText = "";
Color buttonColor = Colors.blue;

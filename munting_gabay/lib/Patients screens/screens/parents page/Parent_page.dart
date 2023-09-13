import 'package:flutter/material.dart';
import 'package:munting_gabay/Patients%20screens/screens/parents%20page/psych.dart';
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
          toolbarHeight: 150,
          iconTheme: IconThemeData(color: BtnColor),
          actions: [
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20),
                  Image.asset(
                    'assets/A.png',
                    height: 150,
                  ),
                  // SizedBox(width: 30), // Add spacing between images
                  Image.asset(
                    'assets/LOGO.png',
                    height: 150,
                    width: 130,
                  ),
                ],
              ),
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 350,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black, // Change the color of the outline
                  width: 2, // Set the width of the outline
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                  child: Text(
                "PARENTS PAGE",
                style: buttonTextStyle,
              )),
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
        buttonColor = Colors.red; // Customize the color for this button
        break;
      case 1:
        buttonText = 'Educational Webinars';
        buttonColor = Colors.green; // Customize the color for this button
        break;
      case 2:
        buttonText = 'Resource Library';
        buttonColor = Colors.orange; // Customize the color for this button
        break;
      case 3:
        buttonText = 'Online Consultation';
        buttonColor = Colors.purple; // Customize the color for this button
        break;
      case 4:
        buttonText = 'Forum and Discussion';
        buttonColor = Colors.teal; // Customize the color for this button
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
              default:
                break;
            }
          },
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
            onPrimary: Colors.white,
          ),
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

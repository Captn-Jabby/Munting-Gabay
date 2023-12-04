import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/finding%20doctor/finding_doctors.dart';
import 'package:munting_gabay/webinars.dart';
import 'package:munting_gabay/resources.dart';
import 'package:munting_gabay/variable.dart';
import 'package:munting_gabay/educational.dart';

import '../../../drawer_page.dart';
import 'forum/forum.dart';

class ParentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: scaffoldBgColor,
          elevation: 0,
          // iconTheme: IconThemeData(color: secondaryColors),
        ),
        drawer: AppDrawer(),
        body: SingleChildScrollView(
            child: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "PARENT'S PAGE",
                  style: buttonTextStyle,
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3.0,
                    crossAxisCount: 1, // Number of columns in the grid
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
        buttonColor = Colors.black; // Customize the color for this button
        break;
      case 1:
        buttonText = 'Educational Videos';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 2:
        buttonText = 'Resource Library';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 3:
        buttonText = 'Forum and Discussion';
        buttonColor = secondaryColor; // Customize the color for this button
        break;
      case 4:
        buttonText = 'Webinars';
        buttonColor = secondaryColor; // Customize the color for this button
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => webinarsScreen()),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookResourcesScreen()),
                );
                break;

              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForumPage()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EducationalVdieosScreen()),
                );
                break;
              default:
                break;
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: secondaryColor),
          child: Text(
            buttonText,
            style: TextStyle(fontSize: 16.0, color: text),
          ),
        ),
      ),
    );
  }
}

String buttonText = "";
Color buttonColor = secondaryColor;

import 'package:flutter/material.dart';

class ParentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parent Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add Forum and Discussion button functionality here
                  print('Forum and Discussion button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
                child: Text('Forum and Discussion'),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add Educational Webinars button functionality here
                  print('Educational Webinars button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                ),
                child: Text('Educational Webinars'),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add Resource Library button functionality here
                  print('Resource Library button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                ),
                child: Text('Resource Library'),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add Online Consultation button functionality here
                  print('Online Consultation button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.purple,
                  onPrimary: Colors.white,
                ),
                child: Text('Online Consultation'),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Add Psychologist Research button functionality here
                  print('Psychologist Research button pressed!');
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white,
                ),
                child: Text('Psychologist Research'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

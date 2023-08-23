import 'package:flutter/material.dart';
import 'package:munting_gabay/variable.dart';

class KidsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        toolbarHeight: 150,
        actions: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/A.png', // Replace with the path to your first image
                  width: 130,
                  height: 150,
                ),
                SizedBox(width: 60), // Add spacing between images
                Image.asset(
                  'assets/LOGO.png',
                  height: 150,
                  width: 130,
                ),
                SizedBox(width: 40),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
              "KIDS PAGE",
              style: buttonTextStyle,
            )),
          ),
          SizedBox(height: 40),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: BtnHeight,
                    ),
                    Image.asset(
                      'assets/LOGO.png',
                      width: LOGOSIZE,
                      height: LOGOSIZE,
                    ),
                    SizedBox(
                      width: lOGOSpacing,
                    ),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BtnCircularRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add Games button functionality here
                          print('Games button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          'Games',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: BtnHeight,
                    ),
                    Image.asset(
                      'assets/LOGO.png',
                      width: LOGOSIZE,
                      height: LOGOSIZE,
                    ),
                    SizedBox(
                      width: lOGOSpacing,
                    ),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BtnCircularRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add Song button functionality here
                          print('Song button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          'Song',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: BtnHeight,
                    ),
                    Image.asset(
                      'assets/LOGO.png',
                      width: LOGOSIZE,
                      height: LOGOSIZE,
                    ),
                    SizedBox(
                      width: lOGOSpacing,
                    ),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BtnCircularRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add Progress Tracker button functionality here
                          print('Progress Tracker button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.orange,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          'Progress Tracker',
                          style: ParentbuttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: BtnHeight,
                    ),
                    Image.asset(
                      'assets/LOGO.png',
                      width: LOGOSIZE,
                      height: LOGOSIZE,
                    ),
                    SizedBox(
                      width: lOGOSpacing,
                    ),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BtnCircularRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add Movies button functionality here
                          print('Movies button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.purple,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          'Movies',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: BtnHeight,
                    ),
                    Image.asset(
                      'assets/LOGO.png',
                      width: LOGOSIZE,
                      height: LOGOSIZE,
                    ),
                    SizedBox(
                      width: lOGOSpacing,
                    ),
                    Container(
                      width: BtnWidth,
                      height: BtnHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(BtnCircularRadius),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Add Videos button functionality here
                          print('Videos button pressed!');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          onPrimary: Colors.white,
                        ),
                        child: Text(
                          'Videos',
                          style: buttonTextStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

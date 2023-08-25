import 'package:flutter/material.dart';
import 'package:munting_gabay/variable.dart';

import '../screens/drawer_page.dart';

class Psychpage extends StatelessWidget {
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
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
                  "PSCYHOLIGIST SEARCH",
                  style: buttonTextStyle,
                )),
              ),
              SizedBox(height: 50),
              Container(
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
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Add Psychologist Name and Addressbutton functionality here
                              print(
                                  'Psychologist Name and Address button pressed!');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            child: Text(
                              'Psychologist Name and Address',
                              style: ParentbuttonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ), //
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
                          width: 10,
                        ),
                        Container(
                          width: BtnWidth,
                          height: BtnHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Add Psychologist Name and Address button functionality here
                              print(
                                  'Psychologist Name and Address button pressed!');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                            ),
                            child: Text(
                              'Psychologist Name and Address',
                              style: ParentbuttonTextStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                    ), //
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
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
                          ),
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: Text(
                              'Psychologist Name and Address',
                              style: ParentbuttonTextStyle,
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
        ),
      ),
    );
  }
}

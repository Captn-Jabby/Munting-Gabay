import 'package:flutter/material.dart';

import 'package:munting_gabay/variable.dart';

import '../../../drawer_page.dart';

class DoctorsHM extends StatelessWidget {
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
                  "DOCTORS PAGE",
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
                              // TODO: Add Forum and Discussion button functionality here
                              print('Forum and Discussion button pressed!');
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              onPrimary: Colors.white,
                            ),
                            child: Text(
                              'Forum and Discussion',
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
                        Container(
                          width: BtnWidth,
                          height: BtnHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
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
                            child: Text(
                              'Educational Webinars',
                              style: ParentbuttonTextStyle,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/LOGO.png',
                          width: LOGOSIZE,
                          height: LOGOSIZE,
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
                        Container(
                          width: BtnWidth,
                          height: BtnHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
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
                            child: Text(
                              'Resource Library',
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
                        Container(
                          width: BtnWidth,
                          height: BtnHeight,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
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
                            child: Text(
                              'Online Consultation',
                              style: ParentbuttonTextStyle,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/LOGO.png',
                          width: LOGOSIZE,
                          height: LOGOSIZE,
                        ),
                        SizedBox(
                          width: lOGOSpacing,
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
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigator.pushReplacement(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => Psychpage()
                              // ),
                              // );
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              onPrimary: Colors.white,
                            ),
                            child: Text(
                              'Psychologist Research',
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

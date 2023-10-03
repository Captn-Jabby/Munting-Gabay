import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:munting_gabay/variable.dart';
import '../../../Doctors screen/movies_screen.dart';
import '../../../drawer_page.dart';
import 'games/main.dart';

class KidsPage extends StatelessWidget {
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
              "KIDS PAGE",
              style: buttonTextStyle,
            ),

              ],
            ),

            SizedBox(height: 40),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/alphabetical.png',
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
                            // TODO: Add Games button functionality here
                            Navigator.push(context, CupertinoPageRoute(builder: (context)=>const KiddieHome()));
                            print('Games button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: secondaryColor
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
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/music.png',
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
                            // TODO: Add Song button functionality here
                            print('Song button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor
                          ),
                          child: Text(
                            'Music',
                            style: buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/movies.png',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageGridScreen()),
                            );
                            print('Movies button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor
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
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/videos.png',
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
                            // TODO: Add Videos button functionality here
                            print('Videos button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor
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
      ),
    );
  }
}

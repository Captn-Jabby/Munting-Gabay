import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/kids_videos.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/musicplayer.dart';

import 'package:munting_gabay/variable.dart';
import 'movies_screen.dart';
import '../../../drawer_page.dart';
import 'games/categories.dart';

class KidsPage extends StatelessWidget {
  const KidsPage({super.key});

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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text('KIDS PAGES', style: smallTextStyle11),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/images/alphabetical.png',
                        width: LOGOSIZE,
                        height: LOGOSIZE,
                      ),
                      const SizedBox(
                        width: lOGOSpacing,
                      ),
                      Container(
                        width: BtnWidth - minus,
                        height: BtnHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BtnCircularRadius),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Add Games button functionality here
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const Categories()));
                            print('Games button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor),
                          child: Text(
                            'Learn',
                            style: buttonTextStyle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/images/music.png',
                        width: LOGOSIZE,
                        height: LOGOSIZE,
                      ),
                      const SizedBox(
                        width: lOGOSpacing,
                      ),
                      Container(
                        width: BtnWidth - minus,
                        height: BtnHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BtnCircularRadius),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const MusicPlayer(
                                          title: 'Music ',
                                        )));

                            print('Song button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor),
                          child: Text(
                            'Music',
                            style: buttonTextStyle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/images/movies.png',
                        width: LOGOSIZE,
                        height: LOGOSIZE,
                      ),
                      const SizedBox(
                        width: lOGOSpacing,
                      ),
                      Container(
                        width: BtnWidth - minus,
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
                                  builder: (context) => const MovieScreen()),
                            );
                            print('Movies button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor),
                          child: Text(
                            'Movies',
                            style: buttonTextStyle1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const SizedBox(
                        width: pageButton,
                      ),
                      Image.asset(
                        'assets/images/videos.png',
                        width: LOGOSIZE,
                        height: LOGOSIZE,
                      ),
                      const SizedBox(
                        width: lOGOSpacing,
                      ),
                      Container(
                        width: BtnWidth - minus,
                        height: BtnHeight,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(BtnCircularRadius),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => const VideoListScreen(
                                        // title: 'Video Player ',
                                        )));
                            print('Videos button pressed!');
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: secondaryColor),
                          child: Text(
                            'Videos',
                            style: buttonTextStyle1,
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

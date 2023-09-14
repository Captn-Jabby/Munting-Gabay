import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/Kids_page.dart';
import 'package:munting_gabay/pincode.dart';
import 'package:munting_gabay/variable.dart';

import 'screens/parents page/Parent_page.dart';
import '../drawer_page.dart';

class HomepagePT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: BtnColor),
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text('Munting\nGabay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5,
                        shadows: [
                          Shadow(
                              color: Color(0xBA205007).withOpacity(1.0),
                              offset: const Offset(7, 2))
                        ],
                        fontSize: 75,
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'A MOBILE-BASED AUTISM AID\nAND AWARENESS APPLICATION',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PinScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(BtnCircularRadius))),
                      child: Text(
                        'Parents',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: BtnSpacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                      border: Border.all(color: Colors.green, width: 2),
                      borderRadius: BorderRadius.circular(BtnCircularRadius),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => KidsPage()),
                        );
                      },
                      child: Text(
                        'Child',
                        style: buttonTextStyle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

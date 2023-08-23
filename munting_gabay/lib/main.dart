import 'package:flutter/material.dart';
import 'package:munting_gabay/home_page.dart';
import 'package:munting_gabay/variable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: scaffoldBgColor,
        elevation: 0,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Image.asset(
              'assets/A.png',
              width: 300,
              height: 300,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  width: BtnWidth,
                  height: BtnHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Homepage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(BtnCircularRadius))),
                    child: Text(
                      'Login',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
                SizedBox(height: BtnSpacing),
                Container(
                  width: BtnWidth,
                  height: BtnHeight,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(BtnCircularRadius),
                      border: Border.all(color: BtnColor)),
                  child: TextButton(
                    onPressed: () {
                      // TODO: Add register functionality here
                      print('Register button pressed!');
                    },
                    child: Text(
                      'Register',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

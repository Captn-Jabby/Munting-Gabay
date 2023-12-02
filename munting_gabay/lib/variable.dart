import 'package:flutter/material.dart';

// scafold settings
const Color secondaryColors = Color(0xFFFA893D);
const Color scaffoldBgColor = Color(0xFF8FCC62); // Use the correct format
const Color secondaryColor = Color(0xFF8FCC62);
const Color LoadingColor = Colors.blue;
const Color bgloadingColor = Colors.grey;
//MediaQuery.of(context).size.height * 0.8,
// Button Settings
final double BtnHeight = 50;
final double BtnWidth = 250;
final double BtnSpacing = 25;
final double BtnCircularRadius = 20;
const Color BtnColor = Colors.blueAccent; //drawer button color

const TextStyle buttonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 28,
  fontWeight: FontWeight.bold,
  // Add more text style properties as needed
);
// Parents page setting
const TextStyle ParentbuttonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  // Add more text style properties as needed
);
// Logo width and height
final double LOGOSIZE = 65;
final double lOGOSpacing = 10;
final double pageButton = 20;
bool callStatus = false;

class UserData {
  final String username;
  final String name;
  final String address;
  final DateTime birthdate;
  final String email;
  final String password;

  UserData({
    required this.username,
    required this.name,
    required this.address,
    required this.birthdate,
    required this.email,
    required this.password,
  });
}

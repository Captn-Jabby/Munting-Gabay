import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// scafold settings
const Color text = Colors.white;
const Color drawertext = Colors.black;
//
Color secondaryColor = Colors.pink;
Color secondaryColors = Color(0xFFFA893D);
Color scaffoldBgColor = Color(0xFF3BD2A5);

// const Color secondaryColors = Color(0xFF8FCC62);
const Color LoadingColor = Colors.blue;
const Color bgloadingColor = Colors.grey;
//MediaQuery.of(context).size.height * 0.8,
// Button Settings
final double BtnHeight = 50;
final double BtnWidth = 250;
final double BtnSpacing = 25;
final double BtnCircularRadius = 20;
// const Color scaffoldBgColor = const Color(0xBA18B091); //drawer button color

const TextStyle buttonTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 28,
  fontWeight: FontWeight.bold,
);
// Parents page setting
const TextStyle ParentbuttonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
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

class ColorAdapter extends TypeAdapter<Color> {
  @override
  final int typeId = 0; // Unique identifier for this adapter

  @override
  Color read(BinaryReader reader) {
    final red = reader.readInt();
    final green = reader.readInt();
    final blue = reader.readInt();
    final alpha = reader.readInt();
    return Color.fromARGB(alpha, red, green, blue);
  }

  @override
  void write(BinaryWriter writer, Color obj) {
    writer.writeInt(obj.red);
    writer.writeInt(obj.green);
    writer.writeInt(obj.blue);
    writer.writeInt(obj.alpha);
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

// scafold settings
const Color text = Colors.black;
const Color drawertext = Colors.white;
//
Color secondaryColor = const Color(0xFF95C440);
// Color secondaryColors = Color(0xFFFA893D);
Color scaffoldBgColor = const Color(0xFFF4F9EC);

////  doctor side
Color DoctorsecondaryColor = const Color(0xFF95C440);
Color DoctorscaffoldBgColor =
    const Color(0xFFF4F9EC); // Dark mode versions of the colors

// Even darker versions of the colors with your variable names
Color darkSecond = const Color(0xFF40620D); // Even more darker color for dark mode
Color darkPrimary = const Color(0xFF888888); // Even more darker color for dark mode

bool darkmode = false;
Color dynamicSecondaryColor = darkmode ? darkSecond : DoctorsecondaryColor;
Color dynamicScaffoldBgColor = darkmode ? darkPrimary : DoctorscaffoldBgColor;
/////

const Color LoadingColor = Colors.blue;
const Color bgloadingColor = Colors.grey;
//MediaQuery.of(context).size.height * 0.8,
// Button Settings
const double BtnHeight = 50;
const double minus = 100;
const double BtnWidth = 350;
const double BtnSpacing = 25;
const double BtnCircularRadius = 20;
// const Color scaffoldBgColor = const Color(0xBA18B091); //drawer button color

final ButtonStyle buttonStyle1 = ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF95C440),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));

final TextStyle buttonTextStyle1 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);
final TextStyle buttonTextStyle12 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

final TextStyle buttonTextStyle2 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Color(0xFF95C440),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);

final TextStyle smallTextStyle11 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 30,
  ),
);
final TextStyle smallTextStyle1 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Color(0xFF9C9C9C),
    fontSize: 14,
  ),
);

final TextStyle smallTextStyle2 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Color(0xFF9C9C9C),
    fontSize: 13,
  ),
);

final TextStyle smallTextStyle3 = GoogleFonts.poppins(
  textStyle: const TextStyle(
    color: Color(0xFF95C440),
    fontSize: 13,
  ),
);
// Parents page setting
const TextStyle ParentbuttonTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);
// Main BG Theme
const BoxDecoration mainBackgroundTheme = BoxDecoration(
  color: Color(0xFFF4F9EC),
);
// Logo width and height
const double LOGOSIZE = 65;
const double lOGOSpacing = 10;
const double pageButton = 20;
bool callStatus = false;

class UserData {
  final String username;
  final String name;
  final String address;
  final DateTime birthdate;
  final String email;
  final String password;
  final String confirmPassword;

  UserData(
      {required this.username,
      required this.name,
      required this.address,
      required this.birthdate,
      required this.email,
      required this.password,
      required this.confirmPassword});
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

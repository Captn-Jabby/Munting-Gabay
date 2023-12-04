import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:hive/hive.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/homepage_PT.dart';
import 'package:munting_gabay/variable.dart';

class ColorChangerScreen extends StatefulWidget {
  @override
  _ColorChangerScreenState createState() => _ColorChangerScreenState();
}

class _ColorChangerScreenState extends State<ColorChangerScreen> {
  late Box<Color> colorBox; // Box to store colors
  @override
  void initState() {
    super.initState();
    colorBox = Hive.box<Color>('colors');
    // Retrieve stored colors if available
    secondaryColor = colorBox.get('secondaryColor') ?? Color(0xFFFA893D);
    scaffoldBgColor = colorBox.get('scaffoldBgColor') ?? Color(0xFF3BD2A5);
  }

  void changeSecondaryColor(Color color) {
    setState(() {
      secondaryColor = color;
      colorBox.put(
          'secondaryColor', color); // Save updated secondaryColor in Hive
    });
  }

  void changeScaffoldBgColor(Color color) {
    setState(() {
      scaffoldBgColor = color;
      colorBox.put(
          'scaffoldBgColor', color); // Save updated scaffoldBgColor in Hive
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Picker'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomepagePT(),
              ),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              color: scaffoldBgColor,
              height: 100,
              width: 100,
              child: Center(
                child: Text(
                  'Sample Text',
                  style: TextStyle(color: secondaryColor),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: secondaryColor,
                          onColorChanged: changeSecondaryColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: true,
                          displayThumbColor: true,
                          showLabel: true,
                          paletteType: PaletteType.hsv,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('Change Secondary Color'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Pick a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: scaffoldBgColor,
                          onColorChanged: changeScaffoldBgColor,
                          colorPickerWidth: 300.0,
                          pickerAreaHeightPercent: 0.7,
                          enableAlpha: true,
                          displayThumbColor: true,
                          showLabel: true,
                          paletteType: PaletteType.hsv,
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text('Change Scaffold Background Color'),
            ),
          ],
        ),
      ),
    );
  }
}

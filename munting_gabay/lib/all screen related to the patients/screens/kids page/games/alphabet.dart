import 'package:flutter/material.dart';

class Alphabet extends StatefulWidget {
  const Alphabet({super.key});

  @override
  State<Alphabet> createState() => _AlphabetState();
}

class _AlphabetState extends State<Alphabet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ALPHABET"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          children: List.generate(26, (index) {
            final letter = String.fromCharCode(index + 65); // Generate A-Z
            final letterSmall = letter.toLowerCase(); // Generate a-z
            return Container(
              child: ElevatedButton(
                onPressed: () {
                  _showLetterDialog(context, letter);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(_getColor(index)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                child: Text(
                  '$letter$letterSmall',
                  style: TextStyle(fontSize: _getFontSize(letter)),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color.fromARGB(255, 158, 83, 172),
      Color.fromARGB(255, 100, 171, 212),
      Color.fromARGB(255, 99, 209, 158),
      Color.fromARGB(255, 224, 115, 142),
    ];
    return colors[index % colors.length];
  }

  double _getFontSize(String letter) {
    return ['M', 'W'].contains(letter) ? 80 : 100;
  }

  void _showLetterDialog(BuildContext context, String letter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You pressed $letter'),
          content: Text('This is the letter $letter'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
// import 'package:audioplayer/audioplayer.dart';

class Numbers extends StatefulWidget {
  const Numbers({super.key});

  @override
  State<Numbers> createState() => _NumbersState();
}

class _NumbersState extends State<Numbers> {
  // final player = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NUMBERS"),
        ),
        body: 
        Container(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15,),
            padding: const EdgeInsets.all(15),
            children: [
//A
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('1', style: TextStyle(fontSize: 100))),
              ),
               ),
//B
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('2', style: TextStyle(fontSize: 100))),
              ),
               ),
//C
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('3', style: TextStyle(fontSize: 100))),
              ),
               ),
//D
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('4', style: TextStyle(fontSize: 100))),
              ),
               ),
//E
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('5', style: TextStyle(fontSize: 100))),
              ),
               ),
//F
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('6', style: TextStyle(fontSize: 100))),
              ),
               ),
//G
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('7', style: TextStyle(fontSize: 100))),
              ),
               ),
//H
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('8', style: TextStyle(fontSize: 100))),
              ),
               ),
//I
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('9', style: TextStyle(fontSize: 100))),
              ),
               ),
//J
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: WidgetStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('10', style: TextStyle(fontSize: 100))),
              ),
               ),
            ],
          ),
        ),
    );
  }
}
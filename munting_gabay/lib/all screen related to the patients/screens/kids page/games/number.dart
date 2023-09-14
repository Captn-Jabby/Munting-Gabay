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
        title: Text("NUMBERS"),
        ),
        body: 
        Container(
          child: GridView(
            children: [
//A
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('1', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              ),
               ),
//B
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('2', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//C
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('3', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//D
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('4', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//E
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('5', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              ),
               ),
//F
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('6', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//G
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('7', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//H
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('8', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
//I
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('9', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              ),
               ),
//J
              Container(
                child: ElevatedButton(onPressed: () {},
              child: (Text('10', style: TextStyle(fontSize: 100))),
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
               ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15,),
            padding: EdgeInsets.all(15),
          ),
        ),
    );
  }
}
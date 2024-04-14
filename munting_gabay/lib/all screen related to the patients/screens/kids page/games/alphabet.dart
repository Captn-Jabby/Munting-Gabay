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
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Aa', style: TextStyle(fontSize: 100))),
              ),
               ),
//B
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Bb', style: TextStyle(fontSize: 100))),
              ),
               ),
//C
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Cc', style: TextStyle(fontSize: 100))),
              ),
               ),
//D
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Dd', style: TextStyle(fontSize: 100))),
              ),
               ),
//E
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Ee', style: TextStyle(fontSize: 100))),
              ),
               ),
//F
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Ff', style: TextStyle(fontSize: 100))),
              ),
               ),
//G
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Gg', style: TextStyle(fontSize: 100))),
              ),
               ),
//H
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Hh', style: TextStyle(fontSize: 100))),
              ),
               ),
//I
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Ii', style: TextStyle(fontSize: 100))),
              ),
               ),
//J
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Jj', style: TextStyle(fontSize: 100))),
              ),
               ),
//K
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Kk', style: TextStyle(fontSize: 100))),
              ),
               ),
//L
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Ll', style: TextStyle(fontSize: 100))),
              ),
               ),
//M
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Mm', style: TextStyle(fontSize: 80))),
              ),
               ),
//N
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Nn', style: TextStyle(fontSize: 100))),
              ),
               ),
//O
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Oo', style: TextStyle(fontSize: 100))),
              ),
               ),
//P
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Pp', style: TextStyle(fontSize: 100))),
              ),
               ),
//Q
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Qq', style: TextStyle(fontSize: 100))),
              ),
               ),
//R
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Rr', style: TextStyle(fontSize: 100))),
              ),
               ),
//S
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Ss', style: TextStyle(fontSize: 100))),
              ),
               ),
//T
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Tt', style: TextStyle(fontSize: 100))),
              ),
               ),
//U
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), 
              shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))
              ),
              child: (const Text('Uu', style: TextStyle(fontSize: 100))),
              ),
               ),
//V
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Vv', style: TextStyle(fontSize: 100))),
              ),
               ),
//W
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 99, 209, 158)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Ww', style: TextStyle(fontSize: 80))),
              ),
               ),
//X
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 224, 115, 142)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Xx', style: TextStyle(fontSize: 100))),
              ),
               ),
//Y
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 158, 83, 172)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Yy', style: TextStyle(fontSize: 100))),
              ),
               ),
//Z
              Container(
                child: ElevatedButton(onPressed: () {},
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color.fromARGB(255, 100, 171, 212)), shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              child: (const Text('Zz', style: TextStyle(fontSize: 100))),
              ),
               ),
            ],
          ),
        ),
    );
  }
}
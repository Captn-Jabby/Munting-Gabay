
import 'package:flutter/material.dart';

class shapes_cat extends StatefulWidget {
  const shapes_cat({super.key});

  @override
  State<shapes_cat> createState() => _shapes_catState();
}

class _shapes_catState extends State<shapes_cat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SHAPES"),
        ),
        body: 
        //CIRCLE
        Container(
          child: GridView(
            children: [
              Container(child: InkWell(onTap: () {
                // final player = AudioCache();
                // player.play('assets/Shapes/circle.mp3');
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Circle.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
               //RECTANGLE
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Rectangle.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
              //SQUARE
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Square.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
//TRIANGLE
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Triangle.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
//HEXAGON
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Hexagon.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
//PENTAGON
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Pentagon.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
//RHOMBUS
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/Shapes/Rhombus.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
              ),
              )
               ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
            padding: EdgeInsets.all(15),
          ),
        ),
    );
  }
}
import 'package:flutter/material.dart';

class colors_cat extends StatefulWidget {
  const colors_cat({super.key});

  @override
  State<colors_cat> createState() => _colors_catState();
}

class _colors_catState extends State<colors_cat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("COLORS"),
        ),
        body: Container(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
            padding: const EdgeInsets.all(15),
            children: [
              //YELLOW
              Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Colors/Red.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
                child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //BLUE
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Colors/Blue.png'),
                  fit: BoxFit.cover),
                   borderRadius: BorderRadius.circular(30)
                ),
                child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //BROWN
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Brown.png'),
                  fit: BoxFit.cover),
                ),
                child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //GREEN
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Green.png'),
                  fit: BoxFit.cover),
                ),
                child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //ORANGE
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Orange.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //PURPLE
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Purple.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //RED
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Yellow.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //PINK
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Pink.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40, color: Colors.white),)),
              ),
              )
               ),
               //BLACK
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/Black.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40, color: Colors.white),)),
              ),
              )
               ),
               //WHITE
               Container(child: InkWell(onTap: () {},
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration( borderRadius: BorderRadius.circular(30),
                  image: const DecorationImage(image: AssetImage('assets/Colors/White.png'),
                  fit: BoxFit.cover),
                ),
              child: const Center(child: Text('', style: TextStyle(fontSize: 40, color: Colors.white),)),
              ),
              )
               ),
            ],
          ),
        ),
    );
  }
}
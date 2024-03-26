import 'package:flutter/material.dart';

class animal_cat extends StatefulWidget {
  const animal_cat({super.key});

  @override
  State<animal_cat> createState() => _animal_catState();
}

class _animal_catState extends State<animal_cat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ANIMALS"),
        ),
        body: 
        //BEE
        Container(
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 15, mainAxisSpacing: 15),
            padding: const EdgeInsets.all(15),
            children: [
              Container(child: InkWell(onTap: () {},
              child: Ink(
                //color: Color(0xffFFDD00),
                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Bee.png'),
                  fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //CAT
              Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Cat.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //DOG
               Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Dog.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //ELEPHANT
               Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Elephant.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //LION
               Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Lion.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //RABBIT
               Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Rabbit.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter, child: const Text('', style: TextStyle(fontSize: 40),)),
              ),
              )
               ),
               //TIGER
               Container(child: InkWell(onTap: () {},
              child: Ink(

                decoration: BoxDecoration(
                  image: const DecorationImage(image: AssetImage('assets/Animals/Tiger.png'),
                  fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30)
                ),
                child: Container(alignment:Alignment.bottomCenter,child: const Text('', style: TextStyle(fontSize: 40),),),
              ),
              )
               )
            ],
          ),
        ),
      );
  }
}
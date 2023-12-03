import 'package:flutter/material.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/games/letters.dart';

import 'shapes.dart';
import 'Colors.dart';
import 'alphabet.dart';
import 'number.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("kiddiElearning"),
      ),
      body: Container(
        child: GridView(
          // ignore: sort_child_properties_last
          children: [
//ALPHABET
            Container(
                child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Alphabet()));
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/Categories/Letter_cut.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                    child: Text(
                  '',
                  style: TextStyle(fontSize: 40),
                )),
              ),
            )),
            Container(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => letters_cat()));
                },
                child: (Text('Letters', style: TextStyle(fontSize: 40))),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.pink),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)))),
              ),
            ),
//COLORS
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Numbers()));
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/Categories/Number_cat.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Container(
                    child: Text(
                  '',
                  style: TextStyle(fontSize: 40),
                )),
              ),
            ),
//SHAPES
            Container(
                child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const shapes_cat()));
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/Categories/Shape_cat.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                    child: Text(
                  '',
                  style: TextStyle(fontSize: 40),
                )),
              ),
            )),
//NUMBERS
            Container(
                child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const colors_cat()));
              },
              child: Ink(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage('assets/Categories/Color_cat.png'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                    child: Text(
                  '',
                  style: TextStyle(fontSize: 40),
                )),
              ),
            )),
          ],
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 50 / 70),
          padding: const EdgeInsets.all(15),
        ),
      ),
    );
  }
}

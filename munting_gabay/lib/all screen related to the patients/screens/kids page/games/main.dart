import 'package:flutter/material.dart';
import 'categories.dart';


void main(List<String> args) {
  runApp(const KiddieHome());
}

class KiddieHome extends StatelessWidget {
  const KiddieHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Categories(),
    );
  }
}
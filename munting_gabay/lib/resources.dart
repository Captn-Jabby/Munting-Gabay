import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BookResourcesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Resources',
      home: BookResourcesScreen(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String description;
  final String coverImage;
  final String link;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.coverImage,
    required this.link,
  });
}

class BookResourcesScreen extends StatelessWidget {
  final List<Book> books = [
    Book(
      title: 'Autism spectrum disorder',
      author: 'Mayo Clinic Press',
      description: 'What is Autism Spectrum Disorder?.',
      coverImage: 'assets/b.png', // Replace with actual asset path
      link:
          'https://www.mayoclinic.org/diseases-conditions/autism-spectrum-disorder/symptoms-causes/syc-20352928',
    ),
    Book(
      title: 'Book Title 2',
      author: 'Author 2',
      description: 'Description of Book 2.',
      coverImage: 'assets/music.png', // Replace with actual asset path
      link: 'https://www.cdc.gov/ncbddd/autism/signs.html',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Resources'),
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(books[index].title),
            subtitle: Text(books[index].author),
            leading: CircleAvatar(
              backgroundImage: AssetImage(books[index].coverImage),
            ),
            onTap: () {
              // Handle tap on the book
              // You can navigate to the book link or perform any other action here
              launchURL(books[index].link);
            },
          );
        },
      ),
    );
  }

  // Function to launch a URL
  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

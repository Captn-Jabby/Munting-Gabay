import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/variable.dart';

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
      title: 'Autism Spectrum Disorder',
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
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
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
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebViewPage(url: books[index].link),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(
          'Web View',
          style: TextStyle(color: text),
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(url)),
      ),
    );
  }
}

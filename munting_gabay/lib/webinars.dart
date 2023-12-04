import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/variable.dart';

class webinars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Educational Webinars',
      home: webinarsScreen(),
    );
  }
}

class Book {
  final String title;
  final String speaker;
  final String description;
  final String coverImage;
  final String link;

  Book({
    required this.title,
    required this.speaker,
    required this.description,
    required this.coverImage,
    required this.link,
  });
}

class webinarsScreen extends StatelessWidget {
  final List<Book> books = [
    Book(
      title: 'Autism Spectrum Disorder',
      speaker: 'Mayo Clinic Press',
      description: 'What is Autism Spectrum Disorder?.',
      coverImage: 'assets/b.jpg', // Replace with actual asset path
      link: 'https://autism.org/webinars/gastrointestinal-autism-research/',
    ),
    Book(
      title: 'From Special to H.A.P.P.Y.',
      speaker:
          'Peter Vermeulen, PhD, in Psychology and Clinical Educational Sciences',
      description:
          'Times have changed. We are looking at autism in a quite different way than we did 20 years ago. We made the move from a purely deficit-based conceptualization of autism towards a neurodiversity perspective where we see neurological differences as a positive thing..',
      coverImage: 'assets/wev1.png', // Replace with actual asset path

      link: 'https://autism.org/from-special-to-happy/',
    ),
    Book(
      title: 'WHAT IS AUTISM?  ',
      speaker: 'ICDL',
      description:
          ' There may be an autism diagnosis or a parent may have been told that their child has a "special need.".',
      coverImage: 'assets/avatar1.png', // Replace with actual asset path
      link:
          'https://autism.org/sensory-considerations-for-social-communication/',
    ),
    Book(
      title: 'WHAT IS AUTISM?  ',
      speaker: 'ICDL',
      description:
          ' There may be an autism diagnosis or a parent may have been told that their child has a "special need.".',
      coverImage: 'assets/avatar1.png', // Replace with actual asset path
      link: 'https://autism.org/webinars/',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentPage(),
                ),
              );
            },
          ),
          backgroundColor: secondaryColor,
          title: Text('Book Resources'),
        ),
        body: ListView.builder(
          itemCount:
              books.length * 2 - 1, // Double the item count to include dividers
          itemBuilder: (context, index) {
            if (index.isOdd) {
              // Return a divider for odd indices
              return Divider(
                thickness: 1, // Set thickness of the divider
                color: Colors.black, // Set color of the divider
              );
            } else {
              // Return ListTile for even indices
              final bookIndex =
                  index ~/ 2; // Calculate index in the original book list
              return ListTile(
                title: Text(books[bookIndex].title),
                subtitle: Text(books[bookIndex].speaker),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(books[bookIndex].coverImage),
                ),
                onTap: () {
                  // Handle tap on the book
                  // You can navigate to the book link or perform any other action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewPage(url: books[bookIndex].link),
                    ),
                  );
                },
              );
            }
          },
        ));
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

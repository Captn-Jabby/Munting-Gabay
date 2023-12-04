import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
import 'package:munting_gabay/variable.dart';

class webinars {
  final String title;

  final String link;

  webinars({
    required this.title,
    required this.link,
  });
}

class EducationalVdieosScreen extends StatelessWidget {
  final List<webinars> webinarss = [
    webinars(
      title: 'WHAT IS AUTISM?  ',
      link: 'https://autism.org/EducationalVdieos/',
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
          title: Text('Edcuational webinars'),
        ),
        body: ListView.builder(
          itemCount: webinarss.length * 2 -
              1, // Double the item count to include dividers
          itemBuilder: (context, index) {
            if (index.isOdd) {
              // Return a divider for odd indices
              return Divider(
                thickness: 1, // Set thickness of the divider
                color: Colors.black, // Set color of the divider
              );
            } else {
              // Return ListTile for even indices
              final webinarsIndex =
                  index ~/ 2; // Calculate index in the original webinars list
              return ListTile(
                title: Text(webinarss[webinarsIndex].title),
                onTap: () {
                  // Handle tap on the webinars
                  // You can navigate to the webinars link or perform any other action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WebViewPage(url: webinarss[webinarsIndex].link),
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

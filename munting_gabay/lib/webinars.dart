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
      title: 'Teacher Christine Joy Asas',
      link:
          'http://www.autismsocietyphilippines.org/2020/10/developing-language-and-reading-skills.html',
    ),
    webinars(
      title: 'WHAT IS AUTISM?  ',
      link:
          'http://www.autismsocietyphilippines.org/2020/10/happily-every-after-virtual-costume.html',
    ),
    webinars(
      title:
          'also referred to as autism spectrum disorder ̶ constitutes a diverse group of conditions related to development of the brain.  ',
      link:
          'https://www.who.int/news-room/fact-sheets/detail/autism-spectrum-disorders?gclid=CjwKCAiAjrarBhAWEiwA2qWdCLYgr5uQSJcK0eHc5n9iaz81lx_FQ4wEvj35nEn1mkpakjUW791mDhoC4-sQAvD_BwE',
    ),
  ];

  EducationalVdieosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const ParentPage(),
                ),
              );
            },
          ),
          backgroundColor: secondaryColor,
          title: const Text('Edcuational webinars'),
        ),
        body: ListView.builder(
          itemCount: webinarss.length * 2 -
              1, // Double the item count to include dividers
          itemBuilder: (context, index) {
            if (index.isOdd) {
              // Return a divider for odd indices
              return const Divider(
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

  const WebViewPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: const Text(
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

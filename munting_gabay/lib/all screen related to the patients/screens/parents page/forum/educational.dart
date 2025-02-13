import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/variable.dart';

class EducationalVdieos {
  final String title;

  final String coverImage;
  final String link;

  EducationalVdieos({
    required this.title,
    required this.coverImage,
    required this.link,
  });
}

class webinarsScreen extends StatelessWidget {
  final List<EducationalVdieos> EducationalVdieoss = [
    EducationalVdieos(
      title: 'Autism / Autism spectrum disorder',

      coverImage: 'assets/images/wan1.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=QnDroP36EuI',
    ),
    EducationalVdieos(
      title: '''Sentis Ky's Story Autism Animation''',

      coverImage: 'assets/images/2.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=qGUhjeZr27g',
    ),
    EducationalVdieos(
      title: 'Fast Facts About Autism (World Autism Awareness Day)',

      coverImage: 'assets/images/3.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=CaRdPYvWt48',
    ),
    EducationalVdieos(
      title: 'Autism Spectrum: Atypical Minds in a Stereotypical World',

      coverImage: 'assets/images/web4.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=j3PrAqJ-H9k',
    ),
    EducationalVdieos(
      title: '2-Minute Neuroscience: Autism',

      coverImage: 'assets/images/5.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=tEBsTX2OVgI',
    ),
    EducationalVdieos(
      title:
          'Autism Spectrum Disorder Mnemonics (Memorable Psychiatry Lecture)',

      coverImage: 'assets/images/6.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=wlUNlaqgs3A',
    ),
    EducationalVdieos(
      title: '''What is Autism? | Cincinnati Children's''',

      coverImage: 'assets/images/7.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=hwaaphuStxY',
    ),
  ];

  webinarsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBgColor,
        appBar: AppBar(
          backgroundColor: secondaryColor,
          title: const Text('Educational Videos'),
        ),
        body: ListView.builder(
          itemCount: EducationalVdieoss.length * 2 -
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
              final EducationalVdieosIndex = index ~/
                  2; // Calculate index in the original EducationalVdieos list
              return ListTile(
                title: Text(EducationalVdieoss[EducationalVdieosIndex].title),
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                      EducationalVdieoss[EducationalVdieosIndex].coverImage),
                ),
                onTap: () {
                  // Handle tap on the EducationalVdieos
                  // You can navigate to the EducationalVdieos link or perform any other action here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewPage(
                          url: EducationalVdieoss[EducationalVdieosIndex].link),
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

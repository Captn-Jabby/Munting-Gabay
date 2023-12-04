import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/parents%20page/Parent_page.dart';
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

      coverImage: 'assets/wan1.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=QnDroP36EuI',
    ),
    EducationalVdieos(
      title: '''Sentis Ky's Story Autism Animation''',

      coverImage: 'assets/2.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=qGUhjeZr27g',
    ),
    EducationalVdieos(
      title: 'Fast Facts About Autism (World Autism Awareness Day)',

      coverImage: 'assets/3.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=CaRdPYvWt48',
    ),
    EducationalVdieos(
      title: 'Autism Spectrum: Atypical Minds in a Stereotypical World',

      coverImage: 'assets/web4.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=j3PrAqJ-H9k',
    ),
    EducationalVdieos(
      title: '2-Minute Neuroscience: Autism',

      coverImage: 'assets/5.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=tEBsTX2OVgI',
    ),
    EducationalVdieos(
      title:
          'Autism Spectrum Disorder Mnemonics (Memorable Psychiatry Lecture)',

      coverImage: 'assets/6.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=wlUNlaqgs3A',
    ),
    EducationalVdieos(
      title: '''What is Autism? | Cincinnati Children's''',

      coverImage: 'assets/7.png', // Replace with actual asset path
      link: 'https://www.youtube.com/watch?v=hwaaphuStxY',
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
          title: Text('Educational Videos'),
        ),
        body: ListView.builder(
          itemCount: EducationalVdieoss.length * 2 -
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

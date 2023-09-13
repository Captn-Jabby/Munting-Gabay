import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import the url_launcher package

class ImageGridScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inspirational Movies '),
      ),
      body: GridView.builder(
        itemCount: 4, // Number of items in the grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in the grid
        ),
        itemBuilder: (context, index) {
          List<String> imagePaths = [
              'assets/mov1.jpg',
            'assets/mov2.jpg',
            'assets/mov3.jpg',
            'assets/mov4.png',
          ];
          List<String> Title = [
            'Rain Man (1988)',
            'Temple Grandin (2010)',
            'The Story of Luke (2012)',
            'A Beautiful Mind (2001)',
          ];
          List<String> moviePrev = [
            'Rain Man (1988) - Directed by Barry Levinson, this classic film stars Dustin Hoffman as an autistic savant named Raymond Babbitt. Tom Cruise plays his brother, who takes him on a cross-country trip. The film offers insight into autism and the complexities of family relationships.',
            'Temple Grandin (2010) - This biographical film tells the inspiring story of Temple Grandin, an autistic woman who becomes a renowned animal behaviorist and advocate for autism awareness. Claire Danes delivers a remarkable performance as Temple Grandin.',
            'The Story of Luke (2012) - This indie drama-comedy focuses on Luke, a young man with autism, as he embarks on a journey of self-discovery and independence after his grandmother passes away. It offers a heartfelt portrayal of the challenges faced by individuals with autism.',
            'A Beautiful Mind (2001) - While not specifically about autism, this film tells the story of John Nash, a brilliant mathematician who struggles with schizophrenia. It showcases the power of the human spirit and determination in overcoming mental health challenges.',
          ];
          List<String> Movietrailler = [
            'https://www.youtube.com/watch?v=mlNwXuHUA8I',
            'https://www.youtube.com/watch?v=cpkN0JdXRpM',
            'https://www.youtube.com/watch?v=i3c6Jy5sHhc',
            'https://www.youtube.com/watch?v=jT51irTIrAc',
          ];


          return GestureDetector(
            onTap: () {
              // Show a dialog with the movie preview when tapped.
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(Title[index]),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(moviePrev[index]),
                        SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            // Use url_launcher to open the movie trailer URL
                            final url = Movietrailler[index];
                            if (await canLaunch(url)) {
                              print ('asdasdas');
                              await launch(url);
                            } else {
                              // Handle the error if the URL cannot be launched
                              print('Could not launch $url');
                            }
                          },
                          icon: Icon(
                            Icons.play_circle,
                            size: 50, // Adjust the size of the icon as needed
                          ),
                          label: Text('Play'),

                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
            child: GridTile(
              child: Column(
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Image.asset(
                      imagePaths[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    Title[index],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

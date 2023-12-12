import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/variable.dart';

class Movie {
  final String title;
  final String imageAsset;
  final String description;
  final String trailerUrl;

  Movie({
    required this.title,
    required this.imageAsset,
    required this.description,
    required this.trailerUrl,
  });
}

List<Movie> movies = [
  Movie(
    title: 'Rain Man (1988)',
    imageAsset: 'assets/images/mov1.jpg',
    description:
        'Directed by Barry Levinson, this classic film stars Dustin Hoffman as an autistic savant named Raymond Babbitt...',
    trailerUrl: 'https://www.youtube.com/watch?v=mlNwXuHUA8I',
  ),
  Movie(
    title: 'Temple Grandin (2010)',
    imageAsset: 'assets/images/mov2.jpg',
    description:
        'This biographical film tells the inspiring story of Temple Grandin, an autistic woman who becomes a renowned animal behaviorist...',
    trailerUrl: 'https://www.youtube.com/watch?v=cpkN0JdXRpM',
  ),
  Movie(
    title: 'The Story of Luke (2012)',
    imageAsset: 'assets/images/mov3.jpg',
    description:
        'This indie drama-comedy focuses on Luke, a young man with autism, as he embarks on a journey of self-discovery and independence...',
    trailerUrl: 'https://www.youtube.com/watch?v=i3c6Jy5sHhc',
  ),
  Movie(
    title: 'A Beautiful Mind (2001)',
    imageAsset: 'assets/images/mov4.png',
    description:
        'While not specifically about autism, this film tells the story of John Nash, a brilliant mathematician who struggles with schizophrenia...',
    trailerUrl: 'https://www.youtube.com/watch?v=jT51irTIrAc',
  ),
];

class MovieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Inspirational Movies'),
      ),
      body: GridView.builder(
        itemCount: movies.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
        ),
        itemBuilder: (context, index) {
          return MovieTile(movie: movies[index]);
        },
      ),
    );
  }
}

class MovieTile extends StatelessWidget {
  final Movie movie;

  MovieTile({required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap to open the movie trailer in an in-app web view
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InAppWebViewPage(movie: movie),
          ),
        );
      },
      child: GridTile(
        child: Column(
          children: [
            Image.asset(
              movie.imageAsset,
              fit: BoxFit.cover,
              width: 150, // Adjust the width and height as needed
              height: 150,
            ),
            Text(movie.title),
          ],
        ),
      ),
    );
  }
}

class InAppWebViewPage extends StatelessWidget {
  final Movie movie;

  InAppWebViewPage({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text(movie.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(url: Uri.parse(movie.trailerUrl)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close Trailer'),
          ),
        ],
      ),
    );
  }
}

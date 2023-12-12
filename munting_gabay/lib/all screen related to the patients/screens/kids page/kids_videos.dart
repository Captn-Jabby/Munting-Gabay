import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:munting_gabay/variable.dart';

class Movie {
  final String title;
  final String imageAsset;

  final String trailerUrl;

  Movie({
    required this.title,
    required this.imageAsset,
    required this.trailerUrl,
  });
}

List<Movie> movies = [
  Movie(
    title: '''There's all kinds of autism''',
    imageAsset: 'assets/images/kid1.jpg',
    trailerUrl: 'https://www.youtube.com/watch?v=MecSNTf4Rw0',
  ),
  Movie(
    title: 'Autism Spectrum',
    imageAsset: 'assets/images/kid2.jpg',
    trailerUrl: 'https://www.youtube.com/watch?v=j3PrAqJ-H9k',
  ),
  Movie(
    title: 'Fast Facts About Autism For Kids',
    imageAsset: 'assets/images/wan1.png',
    trailerUrl: 'https://www.youtube.com/watch?v=dUbsyd8Fnyw',
  ),
  Movie(
    title: '''What is Autism?''',
    imageAsset: 'assets/images/2.png',
    trailerUrl: 'https://www.youtube.com/watch?v=hwaaphuStxY',
  ),
  Movie(
    title: 'Autism Spectrum Disorder Mnemonics',
    imageAsset: 'assets/images/3.png',
    trailerUrl: 'https://www.youtube.com/watch?v=0idZghw97dc',
  ),
];

class KidsVideos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: secondaryColor,
        title: Text('Kids Video'),
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
      child: SingleChildScrollView(
        child: GridTile(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:munting_gabay/all%20screen%20related%20to%20the%20patients/screens/kids%20page/video_player.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  _VideoListScreenState createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  late List<String> videoAssets = [];

  @override
  void initState() {
    super.initState();
    loadVideoAssets();
  }

  Future<void> loadVideoAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    setState(() {
      videoAssets = manifestMap.keys
          .where((String key) => key.startsWith('assets/videos/'))
          .toList();
    });

    print('Video Assets: $videoAssets');

    if (videoAssets == null || videoAssets.isEmpty) {
      print('No video assets found!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video List')),
      body: videoAssets.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: videoAssets.length,
              itemBuilder: (context, index) {
                final videoPath = videoAssets[index];
                final videoName = videoPath.split('/').last;

                return ListTile(
                  title: Text(videoName),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(videoPath: videoPath),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

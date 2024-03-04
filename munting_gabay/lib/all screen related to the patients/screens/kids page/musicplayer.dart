import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class MusicPlayer extends StatefulWidget {
  const MusicPlayer({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  // Variable
  Color bgColor = Colors.blue;
  late AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: bgColor,
      ),
      body: FutureBuilder<String>(
        future: DefaultAssetBundle.of(context).loadString("AssetManifest.json"),
        builder: (context, item) {
          if (item.hasData) {
            Map? jsonMap = json.decode(item.data!);
            List? songs = jsonMap?.keys.toList();

            return ListView.builder(
              itemCount: songs?.length,
              itemBuilder: (context, index) {
                var path = songs![index].toString();
                var title = path.split("/").last.toString(); // Get file name
                title = title.replaceAll("%20", ""); // Remove %20 characters
                title = title.split(".").first;

                return Container(
                  margin:
                      const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(4.0),
                    border: Border.all(
                      color: Colors.white70,
                      width: 1.0,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: ListTile(
                    textColor: Colors.white,
                    title: Text(title),
                    subtitle: Text(
                      "path: $path",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    leading: const Icon(
                      Icons.audiotrack,
                      size: 20,
                      color: Colors.white70,
                    ),
                    onTap: () async {
                      toast(context, "Playing: $title");
                      // Play this song
                      await _player.setAsset(path);
                      await _player.play();
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text("No Songs in the Assets"),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Stop playing
          await _player.stop();
        },
        child: const Icon(Icons.stop),
      ),
    );
  }

  // A toast method
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

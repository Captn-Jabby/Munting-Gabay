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
  List<String> songAssets = [];

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _loadSongs();
  }

  void _loadSongs() async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString("AssetManifest.json");
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final songs = manifestMap.keys
        .where((String key) => key.startsWith('assets/songs/'))
        .toList();
    setState(() {
      songAssets = songs;
    });
  }

  void _playNext() async {
    int currentIndex = _player.currentIndex ?? 0;
    if (currentIndex < songAssets.length - 1) {
      currentIndex++;
      var nextSongPath = songAssets[currentIndex];
      var title = nextSongPath.split("/").last.toString();
      title = title.replaceAll("%20", "");
      title = title.split(".").first;
      _showToast("Playing next: $title");
      await _player.setAsset(nextSongPath);
      await _player.play();
    } else {
      _showToast("End of playlist");
    }
  }

  void _playPrevious() async {
    int currentIndex = _player.currentIndex ?? 0;
    if (currentIndex > 0) {
      currentIndex--;
      var previousSongPath = songAssets[currentIndex];
      var title = previousSongPath.split("/").last.toString();
      title = title.replaceAll("%20", "");
      title = title.split(".").first;
      _showToast("Playing previous: $title");
      await _player.setAsset(previousSongPath);
      await _player.play();
    } else {
      _showToast("Beginning of playlist");
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: bgColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: songAssets.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: songAssets.length,
                    itemBuilder: (context, index) {
                      var path = songAssets[index];
                      var title =
                          path.split("/").last.toString(); // Get file name
                      title =
                          title.replaceAll("%20", ""); // Remove %20 characters
                      title = title.split(".").first;

                      return Container(
                        margin: const EdgeInsets.only(
                            top: 10.0, left: 15.0, right: 15.0),
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
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 12),
                          ),
                          leading: const Icon(
                            Icons.audiotrack,
                            size: 20,
                            color: Colors.white70,
                          ),
                          onTap: () async {
                            _showToast("Playing: $title");
                            await _player.setAsset(path);
                            await _player.play();
                          },
                        ),
                      );
                    },
                  ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: _playPrevious,
                  icon: const Icon(Icons.skip_previous),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  onPressed: () async {
                    await _player.stop();
                  },
                  icon: const Icon(Icons.stop_circle_sharp),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 40,
                  onPressed: _playNext,
                  icon: const Icon(Icons.skip_next),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _player.dispose(); // Dispose the player when the widget is disposed
    super.dispose();
  }
}

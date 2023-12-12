import 'package:flutter/material.dart';
import 'package:munting_gabay/ringtone/flutter_ringtone_player.dart';

import 'android_sound.dart';

class ringtone extends StatelessWidget {
  const ringtone({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Ringtone player'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('playAlarm'),
                  onPressed: () {
                    FlutterRingtonePlayer().playAlarm();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('playAlarm asAlarm: false'),
                  onPressed: () {
                    FlutterRingtonePlayer().playAlarm(asAlarm: false);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('playNotification'),
                  onPressed: () {
                    FlutterRingtonePlayer().playNotification();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('playRingtone'),
                  onPressed: () {
                    FlutterRingtonePlayer().playRingtone();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('Play from asset (android.wav)'),
                  onPressed: () {
                    FlutterRingtonePlayer()
                        .play(fromAsset: "assets/images/ringtone1.mp3");
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('play'),
                  onPressed: () {
                    FlutterRingtonePlayer().play(
                      android: AndroidSounds.notification,
                      looping: true,
                      volume: 1.0,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  child: const Text('stop'),
                  onPressed: () {
                    FlutterRingtonePlayer().stop();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

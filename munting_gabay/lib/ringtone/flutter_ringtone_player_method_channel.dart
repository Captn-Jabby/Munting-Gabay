import 'dart:io';

import 'package:flutter/services.dart';
import 'package:munting_gabay/ringtone/android_sound.dart';

import 'package:path_provider/path_provider.dart';

import 'flutter_ringtone_player_interface.dart';

/// An implementation of [FlutterRingtonePlayerPlatform] that uses method channels.
class MethodChannelFlutterRingtonePlayer extends FlutterRingtonePlayerPlatform {
  final MethodChannel _channel = const MethodChannel('flutter_ringtone_player');

  /// This is generic method allowing you to specify individual sounds
  /// you wish to be played for each platform
  ///
  /// [asAlarm] is an Android only flag that lets play given sound
  /// as an alarm, that is, phone will make sound even if
  /// it is in silent or vibration mode.
  ///
  /// See also:
  ///  * [AndroidSounds]
  ///  * [IosSounds]
  @override
  Future<void> play({
    AndroidSound? android,

    String? fromAsset,
    String? fromFile,
    double? volume,
    bool? looping,
    bool? asAlarm,
  }) async {
    if (fromAsset == null && android == null) {
      throw "Please specify the sound source.";
    }
    if (fromFile != null) {
      fromAsset = await _generateFileUri(fromFile);
    } else if (fromAsset == null) {
      if (android == null) {
        throw "Please specify android sound.";
      }

    } else {
      fromAsset = await _generateAssetUri(fromAsset);
    }
    try {
      var args = <String, dynamic>{};
      if (android != null) args['android'] = android.value;

      if (fromAsset != null) args['uri'] = fromAsset;
      if (looping != null) args['looping'] = looping;
      if (volume != null) args['volume'] = volume;
      if (asAlarm != null) args['asAlarm'] = asAlarm;

      _channel.invokeMethod('play', args);
    } on PlatformException {
      // Not handled
    }
  }

  /// Play default alarm sound (looping on Android)
  @override
  Future<void> playAlarm({
    double? volume,
    bool looping = true,
    bool asAlarm = true,
  }) {
    return play(
      android: AndroidSounds.alarm,

      volume: volume,
      looping: looping,
      asAlarm: asAlarm,
    );
  }

  /// Play default notification sound
  @override
  Future<void> playNotification({
    double? volume,
    bool? looping,
    bool asAlarm = false,
  }) {
    return play(
      android: AndroidSounds.notification,

      volume: volume,
      looping: looping,
      asAlarm: asAlarm,
    );
  }

  /// Play default system ringtone (looping on Android)
  @override
  Future<void> playRingtone({
    double? volume,
    bool looping = true,
    bool asAlarm = false,
  }) {
    return play(
      android: AndroidSounds.ringtone,

      volume: volume,
      looping: looping,
      asAlarm: asAlarm,
    );
  }

  /// Stop looping sounds like alarms & ringtones on Android.
  /// This is no-op on iOS.
  @override
  Future<void> stop() async {
    try {
      _channel.invokeMethod('stop');
    } on PlatformException {
      // Not handled
    }
  }

  /// Generate asset uri according to platform.
  static Future<String> _generateAssetUri(String asset) async {
    if (Platform.isAndroid) {
      // read local asset from rootBundle
      final byteData = await rootBundle.load(asset);

      // create a temporary file on the device to be read by the native side
      final file = File('${(await getTemporaryDirectory()).path}/$asset');
      await file.create(recursive: true);
      await file.writeAsBytes(byteData.buffer.asUint8List());
      return file.uri.path;
    } else if (Platform.isIOS) {
      if (!['wav', 'mp3', 'aiff', 'caf']
          .contains(asset.split('.').last.toLowerCase())) {
        throw 'Format not supported for iOS. Only mp3, wav, aiff and caf formats are supported.';
      }
      return asset;
    } else {
      return asset;
    }
  }

  /// Generate asset uri according to platform.
  static Future<String> _generateFileUri(String asset) async {
    if (Platform.isIOS) {
      if (!['wav', 'mp3', 'aiff', 'caf']
          .contains(asset.split('.').last.toLowerCase())) {
        throw 'Format not supported for iOS. Only mp3, wav, aiff and caf formats are supported.';
      }
    }

    return asset;
  }
}
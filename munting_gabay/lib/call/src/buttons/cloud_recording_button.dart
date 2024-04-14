import 'package:munting_gabay/call/agora_uikit.dart';
import 'package:munting_gabay/call/controllers/rtc_buttons.dart';
import 'package:flutter/material.dart';

class CloudRecordingButton extends StatelessWidget {
  final Widget? child;
  final AgoraClient client;
  const CloudRecordingButton({
    Key? key,
    required this.client,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child != null
        ? RawMaterialButton(
            onPressed: () => toggleCloudRecording(client: client),
            child: child,
          )
        : RecordingStateButton(
            client: client,
          );
  }
}

class RecordingStateButton extends StatelessWidget {
  final AgoraClient client;
  const RecordingStateButton({Key? key, required this.client})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (client.sessionController.value.isCloudRecording) {
      case RecordingState.off:
        return RawMaterialButton(
          onPressed: () => toggleCloudRecording(client: client),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: const Icon(
            Icons.circle_outlined,
            color: Colors.blueAccent,
            size: 20.0,
          ),
        );
      case RecordingState.loading:
        return RawMaterialButton(
          onPressed: () {},
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.white,
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(2),
            child: const CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      case RecordingState.recording:
        return RawMaterialButton(
          onPressed: () => toggleCloudRecording(client: client),
          shape: const CircleBorder(),
          elevation: 2.0,
          fillColor: Colors.blueAccent,
          padding: const EdgeInsets.all(12.0),
          child: const Icon(
            Icons.stop,
            color: Colors.white,
            size: 20.0,
          ),
        );
      default:
        return RawMaterialButton(
          onPressed: () {},
          child: const CircularProgressIndicator(),
        );
    }
  }
}

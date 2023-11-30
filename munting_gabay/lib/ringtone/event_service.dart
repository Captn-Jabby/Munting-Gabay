// EventService.dart

import 'package:event_bus/event_bus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

EventBus eventBus = EventBus();

class RingtoneEvent {}

// VideoCallEvent.dart
class VideoCallEvent {
  final String docId;
  final bool isCalling;

  VideoCallEvent({required this.docId, required this.isCalling});
}

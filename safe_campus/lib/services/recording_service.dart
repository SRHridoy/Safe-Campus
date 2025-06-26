import 'package:flutter_sound/flutter_sound.dart';

class RecordingService {
  late FlutterSoundRecorder recorder;
  String? audioPath;

  Future<void> init() async {
    recorder = FlutterSoundRecorder();
    await recorder.openRecorder();
    recorder.setSubscriptionDuration(Duration(milliseconds: 500));
  }

  Future<void> start() async {
    await recorder.startRecorder(toFile: 'audio.mp3');
    audioPath = 'audio.mp3';
  }

  Future<void> stop() async {
    await recorder.stopRecorder();
  }

  void dispose() {
    recorder.closeRecorder();
  }
}
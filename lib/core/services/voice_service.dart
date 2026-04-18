// TTS wrapper — flutter_tts 4.x
// Android uses the device's built-in TextToSpeech engine: always offline,
// no network permission required.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

final voiceServiceProvider = Provider<VoiceService>((ref) {
  final service = VoiceService();
  ref.onDispose(service.dispose);
  return service;
});

class VoiceService {
  final FlutterTts _tts = FlutterTts();
  bool _ready = false;

  /// Call once before first use (idempotent — safe to call multiple times).
  /// Uses calm settings: 75 % speed, neutral pitch, full volume.
  Future<void> init() async {
    if (_ready) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.75); // slower than default — calming for anxious users
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    _ready = true;
  }

  /// Speak [text], interrupting any currently playing utterance.
  /// No-op if init() has not yet completed.
  Future<void> speak(String text) async {
    if (!_ready) return;
    await _tts.stop(); // cancel current utterance immediately
    await _tts.speak(text);
  }

  /// Cancel any currently playing utterance.
  Future<void> stop() => _tts.stop();

  /// Called by the Riverpod provider on dispose.
  Future<void> dispose() => _tts.stop();
}

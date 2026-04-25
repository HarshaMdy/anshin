// TTS wrapper — flutter_tts 4.x
// Android uses the device's built-in TextToSpeech engine: always offline,
// no network permission required.
//
// Voice settings are tuned for SOS / panic-moment guidance:
//   • rate  0.45 — noticeably slower than default; the word stretches out like
//                  a real breath cue rather than a quick announcement.
//   • pitch 0.85 — slightly lower than neutral; warmer, less clinical-robot.
//   • volume 0.9 — present without startling.
//
// Pre-pause contract:
//   speak() waits 300 ms before uttering the cue. That silence lands at the
//   exact moment the phase changes — it signals "something is shifting" before
//   the voice arrives, matching how a calm coach breathes with the user.
//   A _pendingSpeak flag lets stop() cancel a queued-but-not-yet-spoken cue so
//   no ghost utterance fires after the user exits the SOS screen.
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

  // Set to true by stop() / dispose() so any in-flight pre-pause is cancelled
  // before _tts.speak() is reached.
  bool _stopRequested = false;

  /// Call once before first use (idempotent — safe to call multiple times).
  Future<void> init() async {
    if (_ready) return;
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);  // ~half speed — the word itself feels like a breath
    await _tts.setPitch(0.85);       // slightly lower — warmer, not robotic
    await _tts.setVolume(0.9);
    _ready = true;
  }

  /// Speak [text] after a 300 ms pre-pause.
  ///
  /// The pause is not a delay for its own sake — it's the audible signal that
  /// the phase has changed before the instruction word arrives. Users report
  /// this as more natural than a voice that cuts in mid-animation.
  ///
  /// No-op if init() has not yet completed.
  Future<void> speak(String text) async {
    if (!_ready) return;
    _stopRequested = false;          // fresh call — clear any prior cancel flag
    await _tts.stop();               // cut off any currently-playing utterance
    await Future.delayed(const Duration(milliseconds: 300));
    if (_stopRequested) return;      // user exited during the pre-pause — bail
    await _tts.speak(text);
  }

  /// Cancel any in-flight utterance AND any queued pre-pause.
  Future<void> stop() async {
    _stopRequested = true;
    await _tts.stop();
  }

  /// Called by the Riverpod provider on dispose.
  Future<void> dispose() => stop();
}

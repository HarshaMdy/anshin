// AES-256 CBC encryption for journal text fields.
//
// Key derivation: SHA-256('anshin_journal_aes256_v1_' + userId)
// Stored format:  '{iv_base64}:{ciphertext_base64}'
// Empty string means the field was left blank — returned as-is without decrypt.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

class JournalEncryptionService {
  static const String _pepper = 'anshin_journal_aes256_v1_';
  static const String _separator = ':';

  final enc.Key _key;
  final Random _rng = Random.secure();

  /// Create a service scoped to [userId].
  JournalEncryptionService({required String userId})
      : _key = enc.Key(_deriveKey(userId));

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Encrypts [plaintext] with a fresh random IV.
  /// Returns empty string when [plaintext] is blank.
  String encrypt(String plaintext) {
    if (plaintext.trim().isEmpty) return '';
    final iv = _randomIv();
    final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plaintext, iv: iv);
    final ivB64 = base64.encode(iv.bytes);
    return '$ivB64$_separator${encrypted.base64}';
  }

  /// Decrypts a value produced by [encrypt].
  /// Returns empty string when [stored] is blank or malformed.
  String decrypt(String stored) {
    if (stored.isEmpty) return '';
    final parts = stored.split(_separator);
    if (parts.length < 2) return '';
    try {
      final iv = enc.IV(base64.decode(parts[0]));
      final ciphertext = enc.Encrypted.fromBase64(parts.sublist(1).join(_separator));
      final encrypter = enc.Encrypter(enc.AES(_key, mode: enc.AESMode.cbc));
      return encrypter.decrypt(ciphertext, iv: iv);
    } catch (_) {
      return '';
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  enc.IV _randomIv() {
    final bytes = Uint8List(16);
    for (var i = 0; i < 16; i++) {
      bytes[i] = _rng.nextInt(256);
    }
    return enc.IV(bytes);
  }

  static Uint8List _deriveKey(String userId) {
    final input = utf8.encode('$_pepper$userId');
    final digest = sha256.convert(input);
    return Uint8List.fromList(digest.bytes);
  }
}

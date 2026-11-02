import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Soft tones made in memory. Missing audio never blocks the puzzle.
class AudioService {
  AudioPlayer? _music;
  AudioPlayer? _sfx;
  Uint8List? _musicBytes;
  Uint8List? _tap;
  Uint8List? _tick;
  Uint8List? _connect;
  Uint8List? _invalid;
  Uint8List? _win;
  bool sound = true;
  bool music = true;
  bool _paused = false;
  bool _ready = false;

  Future<void> prepare() async {
    try {
      _tap = _wav(_tone(740, 0.045, volume: 0.22));
      _tick = _wav(_tone(520, 0.03, volume: 0.12));
      _connect = _wav(_tone(680, 0.1, volume: 0.24));
      _invalid = _wav(_tone(170, 0.08, volume: 0.2));
      _win = _wav(_melody(const [523.25, 659.25, 783.99, 1046.5], 0.11, volume: 0.22));
      _musicBytes = _wav(_melody(const [329.63, 392.0, 493.88, 392.0, 329.63, 261.63], 0.62, volume: 0.08));
      _music = AudioPlayer();
      _sfx = AudioPlayer();
      await _music!.setReleaseMode(ReleaseMode.loop);
      await _music!.setVolume(0.22);
      await _sfx!.setVolume(0.7);
      _ready = true;
    } catch (error) {
      debugPrint('audio unavailable: $error');
    }
  }

  Future<void> apply({required bool soundOn, required bool musicOn}) async {
    sound = soundOn;
    music = musicOn;
    if (!_ready) return;
    try {
      if (!musicOn) {
        await _music?.stop();
        return;
      }
      if (!_paused) await _startMusic();
    } catch (error) {
      debugPrint('audio apply failed: $error');
    }
  }

  void unlock() {
    if (_paused || !music) return;
    _startMusic();
  }

  Future<void> pause() async {
    _paused = true;
    try {
      await _music?.pause();
    } catch (_) {}
  }

  Future<void> resume() async {
    _paused = false;
    if (music) await _startMusic();
  }

  void playTap() => _play(_tap);

  void playTick() => _play(_tick);

  void playConnect() => _play(_connect);

  void playInvalid() => _play(_invalid);

  void playWin() => _play(_win);

  Future<void> _startMusic() async {
    if (!_ready || !music || _paused || _music == null || _musicBytes == null) return;
    try {
      if (_music!.state == PlayerState.playing) return;
      await _music!.play(BytesSource(_musicBytes!));
      await _music!.setReleaseMode(ReleaseMode.loop);
    } catch (error) {
      debugPrint('music failed: $error');
    }
  }

  void _play(Uint8List? bytes) {
    if (!_ready || !sound || _paused || bytes == null || _sfx == null) return;
    try {
      _sfx!.play(BytesSource(bytes)).catchError((Object _) {});
    } catch (_) {}
  }

  static List<int> _tone(double freq, double seconds, {required double volume}) {
    const rate = 22050;
    final count = (rate * seconds).round();
    return List<int>.generate(count, (index) {
      final t = index / rate;
      final attack = (index / (rate * 0.012)).clamp(0.0, 1.0);
      final release = ((count - index) / (rate * 0.04)).clamp(0.0, 1.0);
      return (sin(2 * pi * freq * t) * volume * attack * release * 32767).round();
    });
  }

  static List<int> _melody(List<double> notes, double seconds, {required double volume}) {
    final samples = <int>[];
    for (final note in notes) {
      samples.addAll(_tone(note, seconds, volume: volume));
    }
    return samples;
  }

  static Uint8List _wav(List<int> samples) {
    const rate = 22050;
    final dataBytes = samples.length * 2;
    final bytes = ByteData(44 + dataBytes);
    void write(int offset, String value) {
      for (var i = 0; i < value.length; i++) {
        bytes.setUint8(offset + i, value.codeUnitAt(i));
      }
    }

    write(0, 'RIFF');
    bytes.setUint32(4, 36 + dataBytes, Endian.little);
    write(8, 'WAVE');
    write(12, 'fmt ');
    bytes.setUint32(16, 16, Endian.little);
    bytes.setUint16(20, 1, Endian.little);
    bytes.setUint16(22, 1, Endian.little);
    bytes.setUint32(24, rate, Endian.little);
    bytes.setUint32(28, rate * 2, Endian.little);
    bytes.setUint16(32, 2, Endian.little);
    bytes.setUint16(34, 16, Endian.little);
    write(36, 'data');
    bytes.setUint32(40, dataBytes, Endian.little);
    for (var i = 0; i < samples.length; i++) {
      bytes.setInt16(44 + i * 2, samples[i].clamp(-32767, 32767), Endian.little);
    }
    return bytes.buffer.asUint8List();
  }
}

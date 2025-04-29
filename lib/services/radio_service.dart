import 'package:just_audio/just_audio.dart';

class RadioService {
  final _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentStation;

  Future<void> playStation(String url) async {
    try {
      if (_isPlaying) {
        await _player.stop();
      }
      await _player.setUrl(url);
      await _player.play();
      _isPlaying = true;
      _currentStation = url;
    } catch (e) {
      throw Exception('Failed to play radio station: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _player.stop();
      _isPlaying = false;
      _currentStation = null;
    } catch (e) {
      throw Exception('Failed to stop radio: $e');
    }
  }

  bool get isPlaying => _isPlaying;
  String? get currentStation => _currentStation;

  void dispose() {
    _player.dispose();
  }
}

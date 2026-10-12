import 'package:just_audio/just_audio.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  bool get isPlaying => _player.playing;

  Future<void> playAyah(String url) async {
    await _player.setUrl(url);
    await _player.play();
  }

  Future<void> stopAyah() async {
    await _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
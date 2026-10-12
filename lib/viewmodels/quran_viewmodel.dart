import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ayah_model.dart';
import '../services/audio_service.dart';
import '../services/database_service.dart';

enum ViewState { initial, loading, loaded, error }

class QuranViewModel extends ChangeNotifier {
  final DatabaseService _dbService;
  final AudioService _audioService;

  QuranViewModel({
    DatabaseService? dbService,
    AudioService? audioService,
  })  : _dbService = dbService ?? DatabaseService.instance,
        _audioService = audioService ?? AudioService() {
    _listenToAudioState();
  }

  ViewState _state = ViewState.initial;
  ViewState get state => _state;

  List<Ayah> _ayahs = [];
  List<Ayah> get ayahs => _ayahs;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int? _activeAyahId;
  int? get activeAyahId => _activeAyahId;

  bool _isLoadingAudio = false;
  bool get isLoadingAudio => _isLoadingAudio;

  void _listenToAudioState() {
    _audioService.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _activeAyahId = null;
        _isLoadingAudio = false;
        notifyListeners();
      }
    });
  }

  Future<void> loadSurah(int surahNumber) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _ayahs = await _dbService.fetchAyahsBySurah(surahNumber);
      _state = ViewState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> togglePlayAyah(Ayah ayah) async {
    try {
      if (_activeAyahId == ayah.id && _audioService.isPlaying) {
        await _audioService.stopAyah();
        _activeAyahId = null;
        _isLoadingAudio = false;
        notifyListeners();
        return;
      }

      _activeAyahId = ayah.id;
      _isLoadingAudio = true;
      notifyListeners();

      await _audioService.playAyah(ayah.audioUrl);
      _isLoadingAudio = false;
      notifyListeners();
    } catch (e) {
      _activeAyahId = null;
      _isLoadingAudio = false;
      _errorMessage = "Playback error: $e";
      notifyListeners();
    }
  }

  bool isAyahPlaying(int ayahId) {
    return _activeAyahId == ayahId && _audioService.isPlaying;
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import '../models/song_model.dart';
import '../services/audio_player_service.dart';
import '../services/storage_service.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayerService _playerService = AudioPlayerService();
  final StorageService _storageService = StorageService();
  bool _isLoading = false;
  String _error = '';

  // Getters
  AudioPlayerService get playerService => _playerService;
  List<Song> get playlist => _playerService.playlist;
  Song? get currentSong => _playerService.currentSong;
  bool get isPlaying => _playerService.audioPlayer.playing;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Constructor
  AudioProvider() {
    _initAudioPlayer();
    _loadSavedPlaylist();
  }

  // Initialize the audio player
  Future<void> _initAudioPlayer() async {
    try {
      await _playerService.init();
      // Set up listeners for player state changes
      _playerService.audioPlayer.playerStateStream.listen((_) {
        notifyListeners();
      });

      _playerService.audioPlayer.positionStream.listen((_) {
        notifyListeners();
      });
    } catch (e) {
      _error = 'Error initializing audio player: $e';
      print(_error);
    }
  }
  
  // Load saved playlist from storage
  Future<void> _loadSavedPlaylist() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final savedPlaylist = await _storageService.loadPlaylist();
      if (savedPlaylist.isNotEmpty) {
        _playerService.setPlaylist(savedPlaylist);
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error loading saved playlist: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Pick audio files from device
  Future<void> pickAudioFiles() async {
    try {
      _isLoading = true;
      _error = '';
      notifyListeners();

      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        withData: kIsWeb, // Get file bytes for web platform
      );

      if (result != null && result.files.isNotEmpty) {
        for (var file in result.files) {
          if (kIsWeb) {
            // Web platform: use bytes instead of path
            if (file.bytes != null) {
              final song = Song.fromWebFile(
                file.bytes!,
                file.name,
              );
              _playerService.addSong(song);
            }
          } else {
            // Non-web platforms: use file path
            if (file.path != null) {
              final song = Song.fromFilePath(
                file.path!,
                file.name,
              );
              _playerService.addSong(song);
            }
          }
        }
        // Save updated playlist
        await _savePlaylist();
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error picking audio files: $e';
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Play a song by index
  Future<void> playSongAt(int index) async {
    try {
      _error = '';
      await _playerService.playSongAt(index);
      notifyListeners();
    } catch (e) {
      _error = 'Error playing song: $e';
      print(_error);
      notifyListeners();
    }
  }

  // Toggle play/pause
  Future<void> playOrPause() async {
    try {
      _error = '';
      await _playerService.playOrPause();
      notifyListeners();
    } catch (e) {
      _error = 'Error toggling playback: $e';
      print(_error);
      notifyListeners();
    }
  }

  // Play next song
  Future<void> playNext() async {
    try {
      _error = '';
      await _playerService.playNext();
      notifyListeners();
    } catch (e) {
      _error = 'Error playing next song: $e';
      print(_error);
      notifyListeners();
    }
  }

  // Play previous song
  Future<void> playPrevious() async {
    try {
      _error = '';
      await _playerService.playPrevious();
      notifyListeners();
    } catch (e) {
      _error = 'Error playing previous song: $e';
      print(_error);
      notifyListeners();
    }
  }

  // Seek to position
  Future<void> seekTo(Duration position) async {
    try {
      _error = '';
      await _playerService.seekTo(position);
      notifyListeners();
    } catch (e) {
      _error = 'Error seeking: $e';
      print(_error);
      notifyListeners();
    }
  }

  // Remove a song from the playlist
  Future<void> removeSong(String songId) async {
    _playerService.removeSong(songId);
    await _savePlaylist();
    notifyListeners();
  }

  // Clear the playlist
  Future<void> clearPlaylist() async {
    _playerService.clearPlaylist();
    await _storageService.clearSavedPlaylist();
    notifyListeners();
  }
  
  // Save playlist to storage
  Future<void> _savePlaylist() async {
    try {
      await _storageService.savePlaylist(_playerService.playlist);
    } catch (e) {
      _error = 'Error saving playlist: $e';
      print(_error);
    }
  }

  @override
  void dispose() {
    _playerService.dispose();
    super.dispose();
  }
}
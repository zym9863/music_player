import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import 'package:flutter/foundation.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  Song? get currentSong => _currentIndex >= 0 && _currentIndex < _playlist.length 
      ? _playlist[_currentIndex] 
      : null;

  // Initialize the audio player
  Future<void> init() async {
    // Set up stream listeners if needed
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNext();
      }
    });
  }

  // Load a song
  Future<void> loadSong(Song song) async {
    try {
      if (kIsWeb && song.bytes != null) {
        // For web platform, use bytes
        await _audioPlayer.setAudioSource(
          AudioSource.uri(
            Uri.dataFromBytes(
              song.bytes!,
              mimeType: 'audio/${song.filePath.split('.').last}',
            ),
          ),
        );
      } else {
        // For non-web platforms, use file path
        await _audioPlayer.setFilePath(song.filePath);
      }
      
      // Find the index of the song in the playlist
      final index = _playlist.indexWhere((s) => s.id == song.id);
      if (index >= 0) {
        _currentIndex = index;
      }
    } catch (e) {
      print('Error loading song: $e');
      rethrow;
    }
  }

  // Play a song by index
  Future<void> playSongAt(int index) async {
    if (index >= 0 && index < _playlist.length) {
      _currentIndex = index;
      await loadSong(_playlist[index]);
      await _audioPlayer.play();
    }
  }

  // Play/Pause toggle
  Future<void> playOrPause() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      if (_currentIndex < 0 && _playlist.isNotEmpty) {
        await playSongAt(0);
      } else {
        await _audioPlayer.play();
      }
    }
  }

  // Play next song
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;
    
    final nextIndex = (_currentIndex + 1) % _playlist.length;
    await playSongAt(nextIndex);
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;
    
    final previousIndex = _currentIndex <= 0 
        ? _playlist.length - 1 
        : _currentIndex - 1;
    await playSongAt(previousIndex);
  }

  // Seek to a specific position
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Add a song to the playlist
  void addSong(Song song) {
    if (!_playlist.any((s) => s.id == song.id)) {
      _playlist.add(song);
    }
  }

  // Add multiple songs to the playlist
  void addSongs(List<Song> songs) {
    for (final song in songs) {
      addSong(song);
    }
  }

  // Remove a song from the playlist
  void removeSong(String songId) {
    final index = _playlist.indexWhere((s) => s.id == songId);
    if (index >= 0) {
      _playlist.removeAt(index);
      // Adjust current index if needed
      if (_currentIndex >= index) {
        _currentIndex--;
      }
    }
  }

  // Clear the playlist
  void clearPlaylist() {
    _playlist.clear();
    _currentIndex = -1;
  }
  
  // Set playlist (used when loading saved playlist)
  void setPlaylist(List<Song> songs) {
    _playlist = songs;
  }

  // Dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
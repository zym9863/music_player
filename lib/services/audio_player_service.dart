import 'package:just_audio/just_audio.dart';
import '../models/song_model.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

enum LoopMode {
  off,
  all,
  one,
}

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<Song> _playlist = [];
  int _currentIndex = -1;
  LoopMode _loopMode = LoopMode.all;
  bool _isShuffle = false;
  List<int> _shuffledIndices = [];

  // Getters
  AudioPlayer get audioPlayer => _audioPlayer;
  List<Song> get playlist => _playlist;
  int get currentIndex => _currentIndex;
  LoopMode get loopMode => _loopMode;
  bool get isShuffle => _isShuffle;

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
              mimeType: 'audio/${song.filePath.split(".")[1]}',
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

  // Generate shuffled indices
  void _generateShuffledIndices() {
    _shuffledIndices = List.generate(_playlist.length, (index) => index);
    _shuffledIndices.shuffle(Random());
    // Ensure current song is in the first position if shuffle is enabled mid-play
    if (_currentIndex >= 0 && _shuffledIndices.contains(_currentIndex)) {
      _shuffledIndices.remove(_currentIndex);
      _shuffledIndices.insert(0, _currentIndex);
    }
  }

  // Get next index based on current mode
  int _getNextIndex() {
    if (_playlist.isEmpty) return -1;

    // Single loop mode
    if (_loopMode == LoopMode.one) {
      return _currentIndex;
    }

    // Shuffle mode
    if (_isShuffle) {
      if (_shuffledIndices.isEmpty) {
        _generateShuffledIndices();
      }

      final currentShuffledIndex = _shuffledIndices.indexOf(_currentIndex);
      if (currentShuffledIndex == -1) {
        // If current index not found in shuffled list, regenerate
        _generateShuffledIndices();
        return _shuffledIndices.isNotEmpty ? _shuffledIndices[0] : -1;
      }

      final nextShuffledIndex = currentShuffledIndex + 1;
      if (nextShuffledIndex < _shuffledIndices.length) {
        return _shuffledIndices[nextShuffledIndex];
      } else {
        // End of shuffled list, loop if enabled
        return _loopMode == LoopMode.all ? _shuffledIndices[0] : -1;
      }
    }

    // Normal mode (no shuffle)
    final nextIndex = _currentIndex + 1;
    if (nextIndex < _playlist.length) {
      return nextIndex;
    } else {
      // End of playlist, loop if enabled
      return _loopMode == LoopMode.all ? 0 : -1;
    }
  }

  // Get previous index based on current mode
  int _getPreviousIndex() {
    if (_playlist.isEmpty) return -1;

    // Single loop mode
    if (_loopMode == LoopMode.one) {
      return _currentIndex;
    }

    // Shuffle mode
    if (_isShuffle) {
      if (_shuffledIndices.isEmpty) {
        _generateShuffledIndices();
      }

      final currentShuffledIndex = _shuffledIndices.indexOf(_currentIndex);
      if (currentShuffledIndex == -1) {
        // If current index not found in shuffled list, regenerate
        _generateShuffledIndices();
        return _shuffledIndices.isNotEmpty ? _shuffledIndices[0] : -1;
      }

      final previousShuffledIndex = currentShuffledIndex - 1;
      if (previousShuffledIndex >= 0) {
        return _shuffledIndices[previousShuffledIndex];
      } else {
        // Start of shuffled list, loop if enabled
        return _loopMode == LoopMode.all ? _shuffledIndices.last : -1;
      }
    }

    // Normal mode (no shuffle)
    final previousIndex = _currentIndex - 1;
    if (previousIndex >= 0) {
      return previousIndex;
    } else {
      // Start of playlist, loop if enabled
      return _loopMode == LoopMode.all ? _playlist.length - 1 : -1;
    }
  }

  // Play next song
  Future<void> playNext() async {
    if (_playlist.isEmpty) return;

    final nextIndex = _getNextIndex();
    if (nextIndex >= 0) {
      await playSongAt(nextIndex);
    }
  }

  // Play previous song
  Future<void> playPrevious() async {
    if (_playlist.isEmpty) return;

    final previousIndex = _getPreviousIndex();
    if (previousIndex >= 0) {
      await playSongAt(previousIndex);
    }
  }

  // Seek to a specific position
  Future<void> seekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Add a song to the playlist
  void addSong(Song song) {
    if (!_playlist.any((s) => s.id == song.id)) {
      _playlist.add(song);
      // Regenerate shuffled indices if shuffle is enabled
      if (_isShuffle) {
        _generateShuffledIndices();
      }
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
      // Regenerate shuffled indices if shuffle is enabled
      if (_isShuffle) {
        _generateShuffledIndices();
      }
    }
  }

  // Clear the playlist
  void clearPlaylist() {
    _playlist.clear();
    _currentIndex = -1;
    _shuffledIndices.clear();
  }

  // Set playlist (used when loading saved playlist)
  void setPlaylist(List<Song> songs) {
    _playlist = songs;
    // Regenerate shuffled indices if shuffle is enabled
    if (_isShuffle) {
      _generateShuffledIndices();
    }
  }

  // Set loop mode
  void setLoopMode(LoopMode mode) {
    _loopMode = mode;
  }

  // Toggle loop mode (cycle through off -> all -> one)
  LoopMode toggleLoopMode() {
    switch (_loopMode) {
      case LoopMode.off:
        _loopMode = LoopMode.all;
        break;
      case LoopMode.all:
        _loopMode = LoopMode.one;
        break;
      case LoopMode.one:
        _loopMode = LoopMode.off;
        break;
    }
    return _loopMode;
  }

  // Set shuffle mode
  void setShuffle(bool enabled) {
    _isShuffle = enabled;
    if (enabled) {
      _generateShuffledIndices();
    } else {
      _shuffledIndices.clear();
    }
  }

  // Toggle shuffle mode
  bool toggleShuffle() {
    _isShuffle = !_isShuffle;
    if (_isShuffle) {
      _generateShuffledIndices();
    } else {
      _shuffledIndices.clear();
    }
    return _isShuffle;
  }

  // Dispose resources
  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}

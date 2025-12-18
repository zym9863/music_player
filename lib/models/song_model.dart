import 'dart:typed_data';

class Song {
  final String id;
  final String title;
  final String artist;
  final String filePath;
  final Duration duration;
  final String? albumArt;
  final Uint8List? bytes; // Added for web platform
  bool isFavorite; // Added for favorite functionality

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.filePath,
    required this.duration,
    this.albumArt,
    this.bytes,
    this.isFavorite = false,
  });

  // Create a song from a file path with default metadata (for non-web platforms)
  factory Song.fromFilePath(String path, String fileName, {Duration? duration}) {
    // Extract title from filename (remove extension)
    final title = fileName.split('.').first;
    
    return Song(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      artist: 'Unknown Artist',
      filePath: path,
      duration: duration ?? const Duration(seconds: 0),
      albumArt: null,
      bytes: null,
      isFavorite: false,
    );
  }
  
  // Create a song from file bytes (for web platform)
  factory Song.fromWebFile(Uint8List bytes, String fileName, {Duration? duration}) {
    // Extract title from filename (remove extension)
    final title = fileName.split('.').first;
    
    return Song(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      artist: 'Unknown Artist',
      filePath: 'web:', // Use a special prefix for web files
      duration: duration ?? const Duration(seconds: 0),
      albumArt: null,
      bytes: bytes,
      isFavorite: false,
    );
  }
  
  // Convert Song to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'filePath': filePath,
      'duration': duration.inMilliseconds,
      'albumArt': albumArt,
      'isFavorite': isFavorite,
      // Note: bytes are not serialized as they can be large
      // and will be loaded from the file system when needed
    };
  }
  
  // Create a Song from JSON data
  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artist: json['artist'],
      filePath: json['filePath'],
      duration: Duration(milliseconds: json['duration']),
      albumArt: json['albumArt'],
      bytes: null, // Bytes are not stored in JSON
      isFavorite: json.containsKey('isFavorite') ? json['isFavorite'] : false,
    );
  }
}

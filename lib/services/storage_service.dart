import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/song_model.dart';

class StorageService {
  static const String _playlistKey = 'playlist';
  
  // Save playlist to local storage
  Future<bool> savePlaylist(List<Song> playlist) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Convert playlist to JSON
      final List<Map<String, dynamic>> playlistJson = 
          playlist.map((song) => song.toJson()).toList();
      
      // Save as JSON string
      final String playlistString = jsonEncode(playlistJson);
      
      // Store in SharedPreferences
      return await prefs.setString(_playlistKey, playlistString);
    } catch (e) {
      print('Error saving playlist: $e');
      return false;
    }
  }
  
  // Load playlist from local storage
  Future<List<Song>> loadPlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Get JSON string
      final String? playlistString = prefs.getString(_playlistKey);
      
      if (playlistString == null || playlistString.isEmpty) {
        return [];
      }
      
      // Decode JSON string
      final List<dynamic> playlistJson = jsonDecode(playlistString);
      
      // Convert to Song objects
      return playlistJson
          .map((songJson) => Song.fromJson(songJson))
          .toList();
    } catch (e) {
      print('Error loading playlist: $e');
      return [];
    }
  }
  
  // Clear saved playlist
  Future<bool> clearSavedPlaylist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_playlistKey);
    } catch (e) {
      print('Error clearing playlist: $e');
      return false;
    }
  }
}
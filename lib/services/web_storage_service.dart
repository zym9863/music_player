import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/song_model.dart';

/// Web平台特定的存储服务，使用IndexedDB存储音频文件
class WebStorageService {
  static const String _dbName = 'music_player_db';
  static const String _storeName = 'audio_files';
  static const String _metadataKey = 'playlist_metadata';
  
  /// 初始化数据库
  Future<dynamic> _openDatabase() async {
    return html.window.indexedDB!.open(_dbName, version: 1, onUpgradeNeeded: (event) {
      final db = event.target.result;
      if (!db.objectStoreNames!.contains(_storeName)) {
        db.createObjectStore(_storeName);
      }
    });
  }
  
  /// 保存播放列表到IndexedDB
  Future<bool> savePlaylist(List<Song> playlist) async {
    try {
      final db = await _openDatabase();
      final transaction = db.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // 保存元数据
      final List<Map<String, dynamic>> metadataList = 
          playlist.map((song) => song.toJson()).toList();
      final String metadataString = jsonEncode(metadataList);
      store.put(metadataString, _metadataKey);
      
      // 保存音频文件数据
      for (var song in playlist) {
        if (song.bytes != null) {
          store.put(song.bytes, song.id);
        }
      }
      
      db.close();
      return true;
    } catch (e) {
      print('Web存储服务保存播放列表错误: $e');
      return false;
    }
  }
  
  /// 从IndexedDB加载播放列表
  Future<List<Song>> loadPlaylist() async {
    try {
      final db = await _openDatabase();
      final transaction = db.transaction(_storeName, 'readonly');
      final store = transaction.objectStore(_storeName);
      
      // 加载元数据
      final metadataRequest = store.get(_metadataKey);
      final metadataString = await metadataRequest.then((value) => value as String?);
      
      if (metadataString == null || metadataString.isEmpty) {
        db.close();
        return [];
      }
      
      // 解析元数据
      final List<dynamic> metadataList = jsonDecode(metadataString);
      final List<Song> playlist = [];
      
      // 加载每个歌曲的音频数据
      for (var metadata in metadataList) {
        final songId = metadata['id'] as String;
        final bytesRequest = store.get(songId);
        final bytes = await bytesRequest.then((value) => value as Uint8List?);
        
        final song = Song.fromJson(metadata);
        if (bytes != null) {
          // 创建一个新的Song对象，包含音频数据
          final songWithBytes = Song(
            id: song.id,
            title: song.title,
            artist: song.artist,
            filePath: song.filePath,
            duration: song.duration,
            albumArt: song.albumArt,
            bytes: bytes,
          );
          playlist.add(songWithBytes);
        } else {
          playlist.add(song);
        }
      }
      
      db.close();
      return playlist;
    } catch (e) {
      print('Web存储服务加载播放列表错误: $e');
      return [];
    }
  }
  
  /// 清除保存的播放列表
  Future<bool> clearSavedPlaylist() async {
    try {
      final db = await _openDatabase();
      final transaction = db.transaction(_storeName, 'readwrite');
      final store = transaction.objectStore(_storeName);
      
      // 获取元数据以找到所有歌曲ID
      final metadataRequest = store.get(_metadataKey);
      final metadataString = await metadataRequest.then((value) => value as String?);
      
      if (metadataString != null && metadataString.isNotEmpty) {
        final List<dynamic> metadataList = jsonDecode(metadataString);
        
        // 删除所有歌曲数据
        for (var metadata in metadataList) {
          final songId = metadata['id'] as String;
          store.delete(songId);
        }
      }
      
      // 删除元数据
      store.delete(_metadataKey);
      
      db.close();
      return true;
    } catch (e) {
      print('Web存储服务清除播放列表错误: $e');
      return false;
    }
  }
}
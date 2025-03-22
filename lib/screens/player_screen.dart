import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import '../widgets/player_controls.dart';
import '../widgets/progress_bar.dart';
import '../widgets/playlist.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final currentSong = audioProvider.currentSong;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('音乐播放器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: audioProvider.pickAudioFiles,
            tooltip: '添加音乐',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: Column(
        children: [
          // Now playing section
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Album art placeholder with modern design
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    color: AppTheme.darkGrey,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const Icon(
                      Icons.music_note,
                      size: 100,
                      color: AppTheme.lightGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Song info with modern styling
                const SizedBox(height: 30),
                Text(
                  currentSong?.title ?? '未选择歌曲',
                  style: theme.textTheme.displayLarge,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  currentSong?.artist ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.secondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                // Progress bar
                const ProgressBar(),
                const SizedBox(height: 20),
                // Player controls
                const PlayerControls(),
              ],
            ),
          ),
          // Playlist section with modern styling
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: AppTheme.darkGrey.withOpacity(0.7),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '播放列表',
                          style: theme.textTheme.displaySmall,
                        ),
                        if (audioProvider.playlist.isNotEmpty)
                          TextButton.icon(
                            icon: const Icon(
                              Icons.clear_all,
                              color: AppTheme.accentColor,
                            ),
                            label: Text(
                              '清空',
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: AppTheme.accentColor,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: audioProvider.clearPlaylist,
                          ),
                      ],
                    ),
                  ),
                  Expanded(child: const Playlist()),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
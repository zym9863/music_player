import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import '../services/audio_player_service.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlaying;
    final loopMode = audioProvider.loopMode;
    final isShuffle = audioProvider.isShuffle;

    return Column(
      children: [
        // Playback mode controls (loop and shuffle)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shuffle button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                splashColor: AppTheme.accentColor.withOpacity(0.3),
                highlightColor: AppTheme.accentColor.withOpacity(0.1),
                onTap: audioProvider.playlist.isEmpty
                    ? null
                    : () {
                        audioProvider.toggleShuffle();
                      },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    Icons.shuffle,
                    size: 24,
                    color: audioProvider.playlist.isEmpty
                        ? AppTheme.lightGrey.withOpacity(0.5)
                        : isShuffle
                            ? AppTheme.accentColor
                            : AppTheme.textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Loop button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                splashColor: AppTheme.accentColor.withOpacity(0.3),
                highlightColor: AppTheme.accentColor.withOpacity(0.1),
                onTap: audioProvider.playlist.isEmpty
                    ? null
                    : () {
                        audioProvider.toggleLoopMode();
                      },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    loopMode == LoopMode.one
                        ? Icons.repeat_one
                        : Icons.repeat,
                    size: 24,
                    color: audioProvider.playlist.isEmpty
                        ? AppTheme.lightGrey.withOpacity(0.5)
                        : loopMode != LoopMode.off
                            ? AppTheme.accentColor
                            : AppTheme.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Main playback controls (previous, play/pause, next)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Previous button with modern styling
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                splashColor: AppTheme.accentColor.withOpacity(0.3),
                highlightColor: AppTheme.accentColor.withOpacity(0.1),
                onTap: audioProvider.playlist.isEmpty
                    ? null
                    : audioProvider.playPrevious,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.skip_previous_rounded,
                    size: 36,
                    color: audioProvider.playlist.isEmpty
                        ? AppTheme.lightGrey.withOpacity(0.5)
                        : AppTheme.textColor,
                  ),
                ),
              ),
            ),
            
            // Play/Pause button with modern styling
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accentColor,
                    AppTheme.accentColor.withRed((AppTheme.accentColor.red - 30).clamp(0, 255)),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(50),
                  splashColor: Colors.white24,
                  highlightColor: Colors.white10,
                  onTap: audioProvider.playlist.isEmpty
                      ? null
                      : () {
                          audioProvider.playOrPause();
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: FadeTransition(
                            opacity: animation,
                            child: child,
                          ),
                        );
                      },
                      child: Icon(
                        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        key: ValueKey<bool>(isPlaying),
                        size: 42,
                        color: AppTheme.textColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Next button with modern styling
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                splashColor: AppTheme.accentColor.withOpacity(0.3),
                highlightColor: AppTheme.accentColor.withOpacity(0.1),
                onTap: audioProvider.playlist.isEmpty
                    ? null
                    : audioProvider.playNext,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.skip_next_rounded,
                    size: 36,
                    color: audioProvider.playlist.isEmpty
                        ? AppTheme.lightGrey.withOpacity(0.5)
                        : AppTheme.textColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

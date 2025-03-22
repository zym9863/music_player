import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final isPlaying = audioProvider.isPlaying;

    return Row(
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
                      // Add scale animation effect
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
    );
  }
}
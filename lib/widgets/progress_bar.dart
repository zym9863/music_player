import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final audioPlayer = audioProvider.playerService.audioPlayer;

    return StreamBuilder<Duration>(
      stream: audioPlayer.positionStream,
      builder: (context, snapshot) {
        final position = snapshot.data ?? Duration.zero;
        final duration = audioPlayer.duration ?? Duration.zero;
        
        return Column(
          children: [
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 4.0,
                activeTrackColor: AppTheme.accentColor,
                inactiveTrackColor: AppTheme.lightGrey.withOpacity(0.3),
                thumbColor: AppTheme.accentColor,
                thumbShape: const RoundSliderThumbShape(
                  enabledThumbRadius: 6.0,
                  elevation: 4.0,
                ),
                overlayColor: AppTheme.accentColor.withOpacity(0.2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 18.0),
              ),
              child: Slider(
                min: 0,
                max: duration.inMilliseconds.toDouble(),
                value: position.inMilliseconds.toDouble(),
                onChanged: (value) {
                  final newPosition = Duration(milliseconds: value.toInt());
                  audioProvider.seekTo(newPosition);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: TextStyle(
                      color: AppTheme.secondaryTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
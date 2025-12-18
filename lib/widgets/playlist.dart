import 'package:flutter/material.dart';
import '../providers/audio_provider.dart';
import '../theme/app_theme.dart';
import 'package:provider/provider.dart';

class Playlist extends StatelessWidget {
  const Playlist({super.key});

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioProvider>(context);
    final playlist = audioProvider.filteredPlaylist; // 使用筛选后的播放列表
    final currentSong = audioProvider.currentSong;

    if (playlist.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.queue_music_rounded,
              size: 60,
              color: AppTheme.lightGrey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              audioProvider.showOnlyFavorites 
                  ? '暂无收藏歌曲，请先收藏' 
                  : '播放列表为空，请添加音乐',
              style: TextStyle(
                fontSize: 16,
                color: AppTheme.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: playlist.length,
      itemBuilder: (context, index) {
        final song = playlist[index];
        final isCurrentSong = currentSong?.id == song.id;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isCurrentSong ? AppTheme.primaryColor.withOpacity(0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            leading: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: isCurrentSong ? AppTheme.accentColor : AppTheme.darkGrey,
                borderRadius: BorderRadius.circular(10),
                boxShadow: isCurrentSong ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ] : null,
              ),
              child: Icon(
                Icons.music_note_rounded,
                color: isCurrentSong ? AppTheme.textColor : AppTheme.lightGrey,
                size: 22,
              ),
            ),
            title: Text(
              song.title,
              style: TextStyle(
                fontWeight: isCurrentSong ? FontWeight.bold : FontWeight.normal,
                color: isCurrentSong ? AppTheme.accentColor : AppTheme.textColor,
                fontSize: 15,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              song.artist,
              style: TextStyle(
                color: isCurrentSong ? AppTheme.textColor.withOpacity(0.8) : AppTheme.secondaryTextColor,
                fontSize: 13,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 收藏图标
                IconButton(
                  icon: Icon(
                    song.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: song.isFavorite ? AppTheme.accentColor : AppTheme.lightGrey,
                    size: 20,
                  ),
                  splashRadius: 20,
                  onPressed: () => audioProvider.toggleFavorite(song.id),
                  tooltip: song.isFavorite ? '取消收藏' : '收藏',
                ),
                // 删除按钮
                IconButton(
                  icon: Icon(
                    Icons.delete_outline_rounded,
                    color: isCurrentSong ? AppTheme.accentColor : AppTheme.lightGrey,
                    size: 22,
                  ),
                  splashRadius: 24,
                  onPressed: () => audioProvider.removeSong(song.id),
                ),
              ],
            ),
            onTap: () {
              // 查找原始播放列表中的索引
              final originalIndex = audioProvider.playlist.indexWhere((s) => s.id == song.id);
              if (originalIndex != -1) {
                audioProvider.playSongAt(originalIndex);
              }
            },
          ),
        );
      },
    );
  }
}

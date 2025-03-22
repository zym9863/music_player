# Music Player

[中文](README.md) | English

A modern music player application developed with Flutter, supporting multiple platforms (Android, iOS, Web, and Desktop).

![App Icon](assets/image_fx_.jpg)

## Features

- 🎵 **Music Playback Control**: Play, pause, previous track, next track
- 📋 **Playlist Management**: Add, delete, and sort music
- 🔄 **Progress Control**: Drag the progress bar to adjust playback position
- 💾 **Local Storage**: Automatically save playlist and restore on next launch
- 🎨 **Modern UI**: Elegant gradient background and smooth animation effects
- 📱 **Multi-platform Support**: Available for Android, iOS, Web, and Desktop platforms

## Tech Stack

- **Flutter**: Cross-platform UI framework
- **Provider**: State management
- **just_audio**: Audio playback engine
- **file_picker**: File selector
- **shared_preferences**: Local data storage
- **path_provider**: File path management

## Project Structure

```
lib/
├── main.dart              # Application entry point
├── models/               # Data models
│   └── song_model.dart   # Song model
├── providers/            # State management
│   └── audio_provider.dart # Audio state provider
├── screens/              # Screens
│   └── player_screen.dart # Player screen
├── services/             # Services
│   ├── audio_player_service.dart # Audio playback service
│   └── storage_service.dart # Storage service
├── theme/                # Theme
│   └── app_theme.dart    # App theme definition
└── widgets/              # Widgets
    ├── player_controls.dart # Playback control widget
    ├── playlist.dart     # Playlist widget
    └── progress_bar.dart # Progress bar widget
```

## Installation and Running

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- Android Studio / Xcode (for mobile platform development)

### Installation Steps

1. Clone repository
```bash
git clone https://github.com/zym9863/music_player.git
cd music_player
```

2. Install dependencies
```bash
flutter pub get
```

3. Run application
```bash
flutter run
```

## Usage Guide

1. **Add Music**: Click the "+" button in the top right corner of the app bar to select local audio files
2. **Playback Control**: Use the control buttons at the bottom of the interface for play, pause, previous track, next track operations
3. **Adjust Progress**: Drag the progress bar to adjust the current song's playback position
4. **Playlist Management**: Click a song to play directly, long press to delete a song

## Dependencies

This project uses the following main dependencies:

```yaml
dependencies:
  flutter: sdk: flutter
  cupertino_icons: ^1.0.8
  just_audio: ^0.9.36
  file_picker: ^9.2.1
  path_provider: ^2.1.2
  provider: ^6.1.1
  audio_service: ^0.18.12
  just_audio_windows: ^0.2.2
  shared_preferences: ^2.2.2
```

## Contribution Guidelines

Contributions are welcome! Whether it's code contributions, bug reports, or improvement suggestions. Please follow these steps:

1. Fork the project
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details
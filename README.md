# Glow Hockey

A Flutter/Dart neon air-hockey game designed for Android phones.

## Features
- Neon arena, glowing puck and paddles, animated particles and impact flashes.
- 2 vs 2 matches: two paddles on each team.
- Play against AI, with Easy, Medium and Hard difficulty.
- Local 2-player mode (two people share the screen).
- First to 7 goals wins; pause/resume and quick rematch.
- Touch-and-drag controls; supports landscape and portrait layouts.
- No external packages or API keys required.

## Run
1. Install Flutter and Android Studio (with Android SDK).
2. Unzip this project and open a terminal in `GlowHockey`.
3. Run `flutter pub get`.
4. Run `flutter run` with an Android device/emulator connected.

If platform folders are not included, create them once from this folder with `flutter create .` (choose Android when prompted), then run the commands above.

## Controls
- **Vs AI:** drag either cyan paddle with your finger. Teammate and two magenta opponents are AI-controlled.
- **Local 2 Players:** Player 1 controls cyan paddles from the left half; Player 2 controls magenta paddles from the right half.
- First team to 7 goals wins. Tap Pause to pause; tap Resume to continue.

# VibeCheck – Vector Mood Tracker

A modern, high-performance Flutter Web application designed to track your daily emotional journey. Featuring hand-drawn vector expressions and a fluid, animated user interface.

## 🚀 Live Demo
The application is deployed to Vercel. You can view it live here:
**[Insert Your Vercel URL Here]**

## ✨ Features

- **Mood Logging**: Log how you feel from 6 distinct moods: *Happy, Excited, Neutral, Tired, Sad, and Angry*.
- **Custom Vector Graphics**: All mood expressions are rendered directly on the Canvas using Flutter's `CustomPainter`. No images, emojis, or icon fonts are used, ensuring a crisp look at any scale.
- **Interactive Journey**: View your past 7 entries in a beautiful, full-width horizontal timeline.
- **Dynamic Micro-animations**:
  - **Hover Scales**: Mood selectors respond to mouse movements with smooth scaling.
  - **Isolated Bounce**: Tap on any entry in your journey to see a localized "pop" animation.
- **Premium Aesthetic**: 
  - Modern Indigo & Slate color palette.
  - Soft multi-stop gradient backgrounds.
  - Glassmorphic UI containers with deep shadows.
- **UX Focused**: 
  - Time-based personalized greetings.
  - Mouse-drag support for horizontal scrolling on web.
  - Responsive layout constrained for optimal readability.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev) (Web)
- **State Management**: Native `ChangeNotifier` (Lightweight & Reactive)
- **Graphics**: `CustomPainter` & `Path` API for vector rendering.
- **Animations**: `AnimationController` & `TweenSequence`.
- **Deployment**: Configured for [Vercel](https://vercel.com) with `vercel.json` routing.

## 📦 Project Structure

```text
lib/
├── models/
│   └── mood_model.dart     # Mood types and Entry data structures
├── painters/
│   └── mood_painter.dart    # Custom vector rendering logic
├── providers/
│   └── mood_provider.dart   # Native state management logic
├── widgets/
│   └── timeline_card.dart   # Individual animated history cards
└── main.dart               # App entry and UI assembly
```

## 🏗️ Getting Started

### Prerequisites
- Flutter SDK (Stable channel)
- Chrome or any modern web browser

### Local Development
1. Clone the repository:
   ```bash
   git clone https://github.com/filelucker/flutter_mood_tracker_web_app.git
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run -d chrome
   ```

### Build & Deploy
To create a production build:
```bash
flutter build web --release
```

To deploy to Vercel using CLI:
```bash
vercel build/web --prod
```

## 📄 License
This project is open-source and available under the MIT License.

# Kretik — Rate Together

A collaborative group rating app built with Flutter. Create groups, add items, and rate them together with friends and peers.

## Features

- **Group Management** — Create or join groups with invite codes, organize by category
- **Collaborative Ratings** — Add items to groups and rate them on customizable scales (5, 10, 20, 50, 100)
- **AI-Powered Search** — Ask natural language questions about your ratings across all groups
- **User Profiles** — Track your rating activity, groups, and peers
- **Dark Mode** — Full light/dark theme support

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: GetX
- **Backend**: Firebase (Firestore, Auth, Storage)
- **Font**: DM Sans (Google Fonts)
- **Primary Color**: #0BA5EC

## Getting Started

### Prerequisites

- Flutter SDK (3.x+)
- Firebase project configured (see `firebase_options.dart`)
- iOS: Xcode + CocoaPods
- Android: Android Studio + SDK

### Setup

```bash
# Install dependencies
flutter pub get

# Run on device/simulator
flutter run

# Analyze code
flutter analyze
```

## Project Structure

```
lib/
├── core/           # Models, services, routes, utils
├── styles/         # Design tokens (colors, typography, spacing, border radius)
├── ui_components/  # Reusable widgets (buttons, cards, inputs, etc.)
├── pages/          # Feature screens with controllers
├── constants/      # App-wide constants and enums
└── themes/         # Theme configuration
```

## Design System

The app uses a custom design system with semantic tokens:

- **AppColors** — Primary (#0BA5EC), neutrals, feedback colors
- **AppTypography** — DM Sans type scale from Display (48px) to Label (12px)
- **AppSpacing** — xs(4), sm(8), md(16), lg(24), xl(32), xxl(48)
- **AppBorderRadius** — sm(8), md(12), lg(16), xl(20), full(999)

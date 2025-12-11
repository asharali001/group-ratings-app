#!/bin/sh

# Fail on any error
set -e

# The default location for the repo in Xcode Cloud is $CI_PRIMARY_REPOSITORY_PATH
echo "📍 Navigate to project root"
cd $CI_PRIMARY_REPOSITORY_PATH

echo "⬇️ Install Flutter"
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$HOME/flutter/bin:$PATH"

echo "✅ Flutter Version:"
flutter --version

echo "📦 Install Flutter Dependencies"
flutter pub get

echo "🌋 Precache iOS engine"
flutter precache --ios

echo "🧱 Install CocoaPods"
# Note: CocoaPods is pre-installed in Xcode Cloud, but we need to run it to generate the Pods project linking to Flutter.
cd ios
pod install

echo "✨ flutter build ios --config-only (to generate xcconfig)"
# This ensures Generated.xcconfig exists
cd ..
flutter build ios --config-only --no-codesign

echo "✅ Setup Complete"

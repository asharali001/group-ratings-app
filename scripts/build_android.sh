#!/bin/bash
set -e

# ─────────────────────────────────────────────
# Prerequisites
# ─────────────────────────────────────────────

PUBSPEC="pubspec.yaml"
PACKAGE_NAME="com.ratings.group"
AAB_PATH="build/app/outputs/bundle/release/app-release.aab"

# Ensure Java is available (required by Gradle)
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

# Allow overriding the service account path via env var
SERVICE_ACCOUNT_KEY="${PLAY_STORE_JSON_KEY:-android/service-account.json}"

if [ ! -f "$PUBSPEC" ]; then
    echo "❌ Error: pubspec.yaml not found. Run this script from the project root."
    exit 1
fi

if ! command -v fastlane &> /dev/null; then
    echo "❌ fastlane not found."
    echo "   Install it with:  gem install fastlane"
    echo "   Then re-run this script."
    exit 1
fi

if [ ! -f "$SERVICE_ACCOUNT_KEY" ]; then
    echo "❌ Service account JSON not found at: $SERVICE_ACCOUNT_KEY"
    echo ""
    echo "   To create one:"
    echo "   1. Play Console → Setup → API access"
    echo "   2. Link a Google Cloud project and create a service account"
    echo "   3. Grant it 'Release manager' permissions in Play Console"
    echo "   4. Download the JSON key and place it at android/service-account.json"
    echo "      (or set PLAY_STORE_JSON_KEY=/path/to/key.json)"
    echo ""
    exit 1
fi

# ─────────────────────────────────────────────
# 0. Version Bump
# ─────────────────────────────────────────────

CURRENT_VERSION_LINE=$(grep '^version: ' "$PUBSPEC")
FULL_VERSION=${CURRENT_VERSION_LINE#version: }
VERSION_NAME=${FULL_VERSION%+*}
BUILD_NUMBER=${FULL_VERSION#*+}
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))

echo "Current Version: $VERSION_NAME (Build $BUILD_NUMBER)"
echo -n "Enter new version name (Press Enter to keep $VERSION_NAME): "
read INPUT_VERSION_NAME

if [ -z "$INPUT_VERSION_NAME" ]; then
    NEW_VERSION_NAME="$VERSION_NAME"
else
    NEW_VERSION_NAME="$INPUT_VERSION_NAME"
fi

NEW_FULL_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
echo "✅ Updating to: $NEW_FULL_VERSION"

sed -i '' "s/^version: .*/version: $NEW_FULL_VERSION/" "$PUBSPEC"

# ─────────────────────────────────────────────
# 1. Track selection
# ─────────────────────────────────────────────

echo ""
echo "Select Play Store track:"
echo "  1) internal  (default)"
echo "  2) alpha"
echo "  3) beta"
echo "  4) production"
echo -n "Enter choice (Press Enter for internal): "
read TRACK_CHOICE

case "$TRACK_CHOICE" in
    2) TRACK="alpha" ;;
    3) TRACK="beta" ;;
    4) TRACK="production" ;;
    *) TRACK="internal" ;;
esac

echo "✅ Uploading to track: $TRACK"

# ─────────────────────────────────────────────
# 2. Release notes
# ─────────────────────────────────────────────

echo ""
echo "Enter release notes (Press Enter to skip):"
echo -n "> "
read RELEASE_NOTES

CHANGELOG_DIR="fastlane/metadata/android/en-US/changelogs"
mkdir -p "$CHANGELOG_DIR"

if [ -n "$RELEASE_NOTES" ]; then
    echo "$RELEASE_NOTES" > "$CHANGELOG_DIR/$NEW_BUILD_NUMBER.txt"
    echo "✅ Release notes saved."
else
    # Write an empty file so fastlane doesn't use stale notes from a previous build
    echo "" > "$CHANGELOG_DIR/$NEW_BUILD_NUMBER.txt"
    echo "⚠️  No release notes — uploading with empty changelog."
fi

# ─────────────────────────────────────────────
# 3. Clean + Build
# ─────────────────────────────────────────────

echo ""
echo "🧹 Cleaning project..."
flutter clean

echo "🏗️  Building Android App Bundle (this may take a while)..."
flutter build appbundle --release || true

if [ ! -f "$AAB_PATH" ]; then
    echo "❌ Error: Build failed and AAB not found at $AAB_PATH"
    exit 1
fi

echo "✅ Build complete: $AAB_PATH"

# ─────────────────────────────────────────────
# 3. Save a local copy
# ─────────────────────────────────────────────

DATE=$(date "+%Y-%m-%d")
RELEASES_DIR="$HOME/Documents/GroupRatings/AndroidReleases/$DATE"
mkdir -p "$RELEASES_DIR"

VERSION=$(grep '^version: ' "$PUBSPEC" | cut -d ' ' -f 2)
DEST_AAB="$RELEASES_DIR/GroupRatings_v${VERSION}.aab"

if [ -f "$DEST_AAB" ]; then
    TIMESTAMP=$(date "+%H%M%S")
    DEST_AAB="$RELEASES_DIR/GroupRatings_v${VERSION}_${TIMESTAMP}.aab"
fi

cp "$AAB_PATH" "$DEST_AAB"
echo "📦 Saved local copy to: $DEST_AAB"

# ─────────────────────────────────────────────
# 4. Upload to Google Play
# ─────────────────────────────────────────────

echo ""
echo "🚀 Uploading to Google Play ($TRACK)..."

fastlane supply \
    --aab "$AAB_PATH" \
    --package_name "$PACKAGE_NAME" \
    --json_key "$SERVICE_ACCOUNT_KEY" \
    --track "$TRACK" \
    --release_status "completed"

echo ""
echo "✅ Done! AAB uploaded to the '$TRACK' track on Google Play."
echo "   Play Console: https://play.google.com/console"
open "https://play.google.com/console"

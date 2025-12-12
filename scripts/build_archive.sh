#!/bin/bash
set -e

# 0. Version Bump
PUBSPEC="pubspec.yaml"

if [ ! -f "$PUBSPEC" ]; then
    echo "❌ Error: pubspec.yaml not found!"
    exit 1
fi

# Extract current version
# usage: grep to find line, cut to get second part
CURRENT_VERSION_LINE=$(grep '^version: ' "$PUBSPEC")
FULL_VERSION=${CURRENT_VERSION_LINE#version: }
# Split into Name (1.0.5) and Number (5)
VERSION_NAME=${FULL_VERSION%+*}
BUILD_NUMBER=${FULL_VERSION#*+}

# Auto-increment build number
NEW_BUILD_NUMBER=$((BUILD_NUMBER + 1))

echo "Current Version: $VERSION_NAME (Build $BUILD_NUMBER)"

# Prompt for new version name
# -p flag is not always portable, using echo/read
echo -n "Enter new version name (Press Enter to keep $VERSION_NAME): "
read INPUT_VERSION_NAME

if [ -z "$INPUT_VERSION_NAME" ]; then
    NEW_VERSION_NAME="$VERSION_NAME"
else
    NEW_VERSION_NAME="$INPUT_VERSION_NAME"
fi

NEW_FULL_VERSION="$NEW_VERSION_NAME+$NEW_BUILD_NUMBER"
echo "✅ Updating to: $NEW_FULL_VERSION"

# Update pubspec.yaml in-place (macOS sed requires empty string for backup)
sed -i '' "s/^version: .*/version: $NEW_FULL_VERSION/" "$PUBSPEC"

# 1. Clean the project
echo "🧹 Cleaning project..."
flutter clean

# 2. Build the archive
echo "🏗️  Building iOS archive (this may take a while)..."
flutter build ipa --release

# 3. Prepare destination directory
DATE=$(date "+%Y-%m-%d")
ARCHIVES_DIR="$HOME/Library/Developer/Xcode/Archives/$DATE"
mkdir -p "$ARCHIVES_DIR"

# 4. Find the generated archive
SOURCE_ARCHIVE="build/ios/archive/Runner.xcarchive"

if [ ! -d "$SOURCE_ARCHIVE" ]; then
    echo "❌ Error: Archive not found at $SOURCE_ARCHIVE"
    exit 1
fi

# 5. Move and rename the archive to avoid conflicts
# Get version from pubspec.yaml for a meaningful filename
VERSION=$(grep 'version:' pubspec.yaml | head -n1 | cut -d ' ' -f 2)
DESTINATION="$ARCHIVES_DIR/GroupRatings_v$VERSION.xcarchive"

# Handle duplicates by appending a timestamp if needed
if [ -d "$DESTINATION" ]; then
    TIMESTAMP=$(date "+%H%M%S")
    DESTINATION="$ARCHIVES_DIR/GroupRatings_v${VERSION}_${TIMESTAMP}.xcarchive"
fi

echo "📦 Moving archive to Xcode Organizer..."
mv "$SOURCE_ARCHIVE" "$DESTINATION"

# 6. Open it in Xcode
echo "✅ Done! Opening Xcode Organizer..."
open "$DESTINATION"

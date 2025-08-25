# Firebase Setup for Group Ratings App

This document describes the Firebase configuration for the Group Ratings Flutter app.

## Project Information
- **Firebase Project ID**: `v-group-ratings`
- **Project Number**: `167019643162`

## Configured Services

### 1. Authentication
- Firebase Auth is configured and ready to use
- Access via `FirebaseService.auth`

### 2. Firestore Database
- Cloud Firestore is configured and ready to use
- Access via `FirebaseService.firestore`
- Security rules are configured in `firestore.rules`
- Indexes are configured in `firestore.indexes.json`

### 3. Storage
- Firebase Storage is configured and ready to use
- Access via `FirebaseService.storage`
- Security rules are configured in `storage.rules`
- Storage bucket: `v-group-ratings.firebasestorage.app`

## Platform Configurations

### Android
- Package name: `com.ratings.group`
- Configuration file: `android/app/google-services.json`
- Google Services plugin is configured in `android/app/build.gradle.kts`

### iOS
- Bundle ID: `com.ratings.group`
- Configuration file: `ios/Runner/GoogleService-Info.plist`

### Web
- Configuration file: `web/firebase-config.js`
- Note: Web app ID needs to be updated when web app is registered

## Usage

The Firebase services are initialized in `main.dart` and can be accessed through the `FirebaseService` class:

```dart
import 'package:group_ratings_app/core/services/firebase_service.dart';

// Access Firebase services
final auth = FirebaseService.auth;
final firestore = FirebaseService.firestore;
final storage = FirebaseService.storage;
```

## Dependencies

The following Firebase packages are included in `pubspec.yaml`:
- `firebase_core`: Core Firebase functionality
- `firebase_auth`: Authentication services
- `cloud_firestore`: Firestore database
- `firebase_storage`: Cloud storage

## Security Rules

- **Firestore**: Rules are configured in `firestore.rules`
- **Storage**: Rules are configured in `storage.rules`

These rules should be reviewed and customized based on your app's security requirements.

## Deployment

To deploy security rules and indexes:
```bash
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
firebase deploy --only storage
```

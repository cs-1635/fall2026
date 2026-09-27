# 🚀 `api_integration_firebase`
A Flutter example demonstrating **API integration + Provider + MVVM + Firebase** using the **Launch Library 2 (LL2) v2.3.0** public API.

---

## Overview
- **Goal:**  
  Fetch and display upcoming space launches from LL2, show rocket details, and sync select data with Firebase for persistence or analytics.

- **Patterns:**  
  **MVVM architecture** with `Provider` for dependency injection and state management.  
  **Repository boundary** integrates both remote (LL2 API) and cloud (Firebase) data sources.

- **Why:**  
  Keep networking, caching, and JSON parsing separate from the UI.  
  Enable cloud persistence, offline viewing, and usage tracking through Firebase.

---

## Stack
- **Flutter** (mobile + web)
- **Provider** (`ChangeNotifier`, `ProxyProvider`) for state/DI
- **Firebase** (Firestore + Core + Analytics + Crashlytics)
- **HTTP** for Launch Library API calls
- **Intl** for date formatting
- **Launch Library 2 API** (https://ll.thespacedevs.com/2.3.0/)

---

## Architecture
```
[ LL2 API ]  ←→  (HTTP)
[ Firebase (Firestore/Analytics) ]  ←→  (Cloud Sync)
          ↑ ↓
[ Service Layer ]          // ll2_api.dart + firebase_service.dart
          ↑ ↓
[ Repository Layer ]       // Combines API + Firebase cache
          ↑ ↓
[ ViewModels ]             // Manage loading/error/data state
          ↑ ↓
[ Views / Widgets ]        // Bind via Provider (watch/read/select)
```

**Rules:**
- **Views** never call HTTP or Firebase directly.  
- **ViewModels** never import networking or Firebase packages directly.  
- **Services** handle all I/O; **Repository** mediates between remote and local/cloud sources.  
- All dependencies are injected via **Provider** in `main.dart`.

---

## Folder Layout
```
lib/
  models/             # LaunchModel, RocketModel, etc.
  services/           # ll2_api.dart, firebase_service.dart
  repositories/       # launchRepository.dart
  viewModels/         # LaunchListVM, LaunchDetailVM
  views/              # launchListView.dart, launchDetailView.dart
  widgets/            # launchTileWidget.dart
  main.dart           # Provider wiring + Firebase init + MaterialApp
```

---

## Firebase Setup
1. Add to `pubspec.yaml`:
   ```yaml
   dependencies:
     firebase_core: ^3.3.0
     cloud_firestore: ^5.4.0
     firebase_analytics: ^11.1.0
     firebase_crashlytics: ^4.1.0
   ```

2. Configure your Firebase project:  
   - Run `flutterfire configure`  
   - Verify `firebase_options.dart` exists under `lib/`  
   - Initialize Firebase in `main.dart` before running the app:
     ```dart
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
     ```

3. Optional: enable offline persistence in Firestore:
   ```dart
   FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
   ```

---

## Updated Repository Layer

The `LaunchRepository` now manages **two data sources**:
```dart
class LaunchRepository {
  final LaunchLibraryApi api;
  final FirebaseService firebase;

  LaunchRepository(this.api, this.firebase);

  Future<List<LaunchModel>> upcomingLaunches({int limit = 10}) async {
    final launches = await api.getUpcomingLaunches(limit);
    await firebase.cacheLaunches(launches); // store summary in Firestore
    return launches;
  }

  Future<RocketModel> rocketFor(String configId) async {
    final rocket = await api.getLauncherConfiguration(configId);
    await firebase.logRocketViewed(configId);
    return rocket;
  }
}
```

---

## Firebase Service

Example responsibilities:
- `cacheLaunches(List<LaunchModel>)` → writes lightweight launch data to Firestore  
- `getCachedLaunches()` → reads local/Firestore cache when offline  
- `logRocketViewed(String id)` → tracks user interaction for analytics  

---

## Firebase Integration Diagram

```
        ┌────────────────────────────┐
        │      LaunchListView        │
        │ (UI watches ViewModel data)│
        └─────────────┬──────────────┘
                      │  notifyListeners()
                      ▼
        ┌────────────────────────────┐
        │     LaunchListVM           │
        │ (Holds state & triggers)   │
        └─────────────┬──────────────┘
                      │  via repository
                      ▼
        ┌────────────────────────────┐
        │    LaunchRepository        │
        │ (Bridges API + Firebase)   │
        └─────────────┬──────────────┘
        ▲             │              ▲
 (HTTP) │             │ (Cloud sync) │ (Analytics)
        ▼             ▼              ▼
┌────────────┐   ┌────────────┐   ┌────────────┐
│ LL2 API    │   │ Firebase   │   │ Analytics  │
│ Service    │   │ Firestore  │   │ (optional) │
└────────────┘   └────────────┘   └────────────┘
```

---

## Run

Android/iOS:
```bash
flutter run
```

Web (Chrome):
```bash
flutter run -d chrome --web-renderer canvaskit
```

Make sure you have initialized Firebase in the project before running.

---

## Troubleshooting

**ProviderNotFoundException**
- Verify that `MultiProvider` wraps `MaterialApp` in `main.dart`.
- After changing providers, perform a **Hot Restart**.
- Check imports (`package:` paths) to avoid duplicate type instances.
- Use `context.read()` in `initState` (not `watch`).

**Firebase issues**
- Make sure `firebase_options.dart` exists.
- Check that your Google Services config files are present (`google-services.json`, `GoogleService-Info.plist`).
- Enable the Firestore API in your Firebase console if you use caching.

---

## What to Try Next
- Add offline “recently viewed” launches backed by Firestore cache.  
- Add Analytics to track most viewed rocket configurations.  
- Sync user favorites to Firebase.  
- Add local persistence via `shared_preferences` for lightweight offline mode.  
- Show a Firebase-backed “Last synced” timestamp in the UI.

---

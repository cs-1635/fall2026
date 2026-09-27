# api_integration

A Flutter example that demonstrates **API integration + Provider + MVVM** using the **Launch Library 2 (LL2) v2.3.0** public API.

---

## Overview
- **Goal:** Fetch a list of upcoming space launches, show details, and lazy-load rocket configuration.
- **Patterns:** MVVM with a **Repository** boundary and **Provider** for dependency injection/state.
- **Why:** Keep networking and JSON parsing out of the UI, make changes cheap, and enable easy testing later.

---

## Stack
- Flutter (mobile + web)
- `provider` for DI/state (`ChangeNotifier`, `ProxyProvider`)
- `http` for networking
- `intl` for date formatting
- Launch Library 2 API (https://ll.thespacedevs.com/2.3.0/)

---

## Architecture
```
[ LL2 API ]
    ↑ ↓  (HTTP)
[ Service: LaunchLibraryApi ]   // raw I/O and JSON→Model
    ↑ ↓
[ Repository: LaunchRepository ] // app data contract (room for cache/offline)
    ↑ ↓
[ ViewModels ]                   // loading/error/data
    ↑ ↓
[ Views / Widgets ]              // read/watch via Provider
```

**Rules:**
- Views never call `http` or parse JSON.
- ViewModels do not import the HTTP client.
- Services handle HTTP; Repository is the VM-facing API.
- Provide dependencies at the app root; typically one VM per screen.

---

## Folder Layout
```
lib/
  models/         # LaunchModel, RocketModel
  services/       # ll2_api.dart (HTTP client)
  repositories/   # launchRepository.dart
  viewModels/     # LaunchListVM, LaunchDetailVM
  views/          # launchListView.dart, launchDetailView.dart
  widgets/        # launchTileWidget.dart
  main.dart       # Provider wiring + MaterialApp
```

---

## Setup

Add dependencies in `pubspec.yaml`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.0.5
  http: ^1.2.2
  intl: ^0.19.0
```

Fetch packages:
```bash
flutter pub get
```

---

## Run

Android/iOS:
```bash
flutter run
```

Web (Chrome):
```bash
flutter run -d chrome
# If you see weird pointer assertions on web:
flutter run -d chrome --web-renderer canvaskit
```

---

## Key Files

- **Service:** `lib/services/ll2_api.dart`  
  - `getUpcomingLaunches(limit)`  
  - `getLauncherConfiguration(id)`

- **Repository:** `lib/repositories/launchRepository.dart`  
  - `upcomingLaunches({limit})`  
  - `rocketFor(rocketConfigId)`

- **ViewModels:**  
  - `LaunchListVM` loads upcoming launches  
  - `LaunchDetailVM` loads rocket configuration on demand

- **Views:**  
  - `launchListView.dart` renders list and navigates to details  
  - `launchDetailView.dart` shows mission text, local time, rocket info

- **Widgets:**  
  - `launchTileWidget.dart` thumbnail, name, friendly date

- **App wiring:** `lib/main.dart` (Providers + `MaterialApp`)

---

## Troubleshooting

**ProviderNotFoundException**
- Ensure `MultiProvider` wraps `MaterialApp` in `main.dart`.
- After adding or changing providers, do a **Hot Restart** (not just hot-reload).
- Use consistent `package:` imports and consistent folder casing to avoid duplicate types (especially on web).
- In `initState`, use `context.read<...>()` (not `watch`) to trigger initial loads, often via `Future.microtask`.

**HTTP/JSON errors**
- Check console output from the service methods for status codes and payloads.
- LL2 is public; no key is required for basic browsing endpoints.

---

## What to Try Next
- Add a “Next 7 days” filter with `net__gte`/`net__lte`.
- Implement pagination using LL2’s `next` link.
- Add basic caching in the repository (e.g., last successful result with an age label).

---

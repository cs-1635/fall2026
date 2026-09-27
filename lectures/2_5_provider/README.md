# Flutter Provider Demos

This project is a **single Flutter app** showcasing common usage patterns of the [`provider`](https://pub.dev/packages/provider) package.  
Each demo is self-contained and accessible from a simple menu.

The goal is to serve as a learning playground and reference for:
- `Provider` (immutable values like configs, repositories)
- `ChangeNotifierProvider` (mutable state with notifications)
- `FutureProvider` (async data loaded once)
- `StreamProvider` (live async data, multiple updates)
- `ProxyProvider` (build a value from other providers)

---

## 📂 Demos Included

1. **Provider (simple value)**  
   Provide immutable config and read it anywhere in the widget tree.

2. **ChangeNotifierProvider**  
   Classic counter app with `watch`, `read`, `Consumer`, and `Selector`.

3. **FutureProvider**  
   Load async data (e.g., user profile) and rebuild UI when it’s ready.

4. **FutureProvider + ViewModel**  
   Separate business logic into a ViewModel; expose only the data via `FutureProvider`.

5. **StreamProvider**  
   Live updates from a ticker stream (`Stream<int>`).

6. **StreamProvider + ViewModel**  
   A ViewModel owns the stream lifecycle (timer + controller); the UI consumes the data.

7. **ProxyProvider**  
   Compose dependencies: `ApiClient` is derived from `AppConfig` + `AuthVM`.  
   When `AuthVM`’s token changes, `ApiClient` automatically updates without being recreated.

---

## 🚀 Getting Started

### Requirements
- Flutter 3.x
- Dart 3.x
- [`provider`](https://pub.dev/packages/provider) ^6.0.5 (already in `pubspec.yaml`)

### Run
```bash
flutter pub get
flutter run
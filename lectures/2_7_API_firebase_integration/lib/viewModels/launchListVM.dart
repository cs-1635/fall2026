import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/launchModel.dart';
import '../repositories/launchRepository.dart';

class LaunchListVM extends ChangeNotifier {
  final LaunchRepository _repo;
  LaunchListVM(this._repo) {
    // Start watching favorites immediately
    _favSub = _repo.favoritesStream().listen((ids) {
      _favorites
        ..clear()
        ..addAll(ids);
      notifyListeners();
    });
  }

  bool _loading = false; bool get loading => _loading;
  String? _error; String? get error => _error;

  final List<LaunchModel> _items = [];
  List<LaunchModel> get items => List.unmodifiable(_items);

  final Set<String> _favorites = <String>{};
  Set<String> get favorites => Set.unmodifiable(_favorites);

  StreamSubscription<List<String>>? _favSub;

  Future<void> load() async {
    _loading = true; _error = null; notifyListeners();
    try {
      final data = await _repo.upcomingLaunches(limit: 30);
      _items
        ..clear()
        ..addAll(data);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }

  bool isFavorite(String launchId) => _favorites.contains(launchId);

  Future<void> toggleFavorite(LaunchModel m) async {
    try {
      if (isFavorite(m.id)) {
        await _repo.removeFavorite(m.id);
      } else {
        await _repo.addFavorite(m);
      }
      // _favorites will update via the stream; no need to mutate locally
    } catch (e) {
      _error = 'Favorite failed: $e';
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _favSub?.cancel();
    super.dispose();
  }
}
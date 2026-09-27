import 'package:flutter/foundation.dart';
import '../models/launchModel.dart';
import '../repositories/launchRepository.dart';

class LaunchListVM extends ChangeNotifier {
  final LaunchRepository _repo;
  LaunchListVM(this._repo);

  var _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<LaunchModel> _items = [];
  List<LaunchModel> get items => _items;

  Future<void> load() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _items = await _repo.upcomingLaunches();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false; notifyListeners();
    }
  }
}
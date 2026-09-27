import 'package:flutter/foundation.dart';
import '../models/launchModel.dart';
import '../models/rocketModel.dart';        // Map this to launcher_config response
import '../repositories/launchRepository.dart';

class LaunchDetailVM extends ChangeNotifier {
  final LaunchRepository _repo;
  final LaunchModel launchModel;
  LaunchDetailVM(this._repo, this.launchModel);

  RocketModel? _rocket;
  RocketModel? get rocket => _rocket;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  /// Fetch the rocket configuration for this launch.
  /// Set [force] true to re-fetch even if already loaded.
  Future<void> loadRocket({bool force = false}) async {
    if (!force && _rocket != null) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      // Launch Library 2: use launcher_configurations/{id}/
      _rocket = await _repo.rocketFor(launchModel.rocketConfigId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
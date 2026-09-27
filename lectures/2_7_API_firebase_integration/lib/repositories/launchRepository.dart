import '../models/launchModel.dart';
import '../models/rocketModel.dart';
import '../services/LaunchLibraryApi.dart';
import '../services/firebaseService.dart';

/// Repository combining remote API data with Firebase user state.
class LaunchRepository {
  final LaunchLibraryApi api;
  final FirebaseService firebase;
  LaunchRepository(this.api, this.firebase);

  Future<List<LaunchModel>> upcomingLaunches({int limit = 20}) =>
      api.getUpcomingLaunches(limit: limit);

  Future<RocketModel> rocketFor(int rocketConfigId) =>
      api.getLauncherConfiguration(rocketConfigId);

  /// Firestore favorites access
  Stream<List<String>> favoritesStream() => firebase.favoritesStream();

  Future<void> addFavorite(LaunchModel model) async {
    await firebase.addFavorite(model.id, {
      'name': model.name,
      'net': model.net.toIso8601String(),
      'rocket': model.rocketFullName,
    });
  }

  Future<void> removeFavorite(String launchId) =>
      firebase.removeFavorite(launchId);

  Future<List<String>> friendFavorites(String friendId) =>
      firebase.getFriendFavorites(friendId);
}
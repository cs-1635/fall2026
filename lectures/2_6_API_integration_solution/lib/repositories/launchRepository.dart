import '../models/launchModel.dart';
import '../models/rocketModel.dart';
import '../services/LaunchLibraryApi.dart';



class LaunchRepository {
  final LaunchLibraryApi api;
  LaunchRepository(this.api);

  Future<List<LaunchModel>> upcomingLaunches({int limit = 20}) =>
      api.getUpcomingLaunches(limit: limit);

  Future<RocketModel> rocketFor(int rocketConfigId) =>
      api.getLauncherConfiguration(rocketConfigId);
}
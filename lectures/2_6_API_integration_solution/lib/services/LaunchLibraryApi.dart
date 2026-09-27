import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/launchModel.dart';
import '../models/rocketModel.dart';

class LaunchLibraryApi {
  final http.Client _client;
  static const _base = 'https://ll.thespacedevs.com/2.3.0';

  LaunchLibraryApi(this._client);

  /// Upcoming launches from now onward, ordered by time.
  Future<List<LaunchModel>> getUpcomingLaunches({int limit = 20}) async {
    final now = DateTime.now().toUtc().toIso8601String();
    final uri = Uri.parse('$_base/launches/?limit=$limit&net__gte=$now&ordering=net');
    final r = await _client.get(uri);
    if (r.statusCode != 200) {
      throw Exception('Launches ${r.statusCode}: ${r.body}');
    }
    final root = jsonDecode(r.body) as Map<String, dynamic>;
    final results = (root['results'] as List).cast<Map<String, dynamic>>();
    return results.map(LaunchModel.fromJson).toList();
  }

  /// Details for the rocket configuration shown on a launch.
  Future<RocketModel> getLauncherConfiguration(int id) async {
    final uri = Uri.parse('$_base/launcher_configurations/$id/');
    final r = await _client.get(uri);
    if (r.statusCode != 200) {
      throw Exception('LauncherConfig ${r.statusCode}: ${r.body}');
    }
    return RocketModel.fromJson(jsonDecode(r.body) as Map<String, dynamic>);
  }
}
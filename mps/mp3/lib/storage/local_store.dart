import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models.dart';

class LocalStore {
  static const _kPositions = 'positions_with_prices';

  Future<List<Position>> readPositions() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPositions);
    if (raw == null) {
      // default starter list (use doubles)
      return const [Position(symbol: 'AAPL', qty: 2.0), Position(symbol: 'MSFT', qty: 1.0)];
    }
    final List list = jsonDecode(raw) as List;
    return list.map((e) => Position.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> writePositions(List<Position> positions) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(positions.map((e) => e.toJson()).toList());
    await prefs.setString(_kPositions, encoded);
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models.dart';

/// Very small Finnhub WS client that manages subscriptions and emits ticks.
class MarketDataService {
  WebSocketChannel? _channel;
  final _subs = <String>{};
  bool _connecting = false;

  final _tickCtl = StreamController<PriceTick>.broadcast();
  Stream<PriceTick> get ticks => _tickCtl.stream;

  Future<void> connect() async {
    if (_channel != null || _connecting) return;
    _connecting = true;
    final token = "d3r60tpr01qopgh74f4gd3r60tpr01qopgh74f50";
    if (token.isEmpty) { _connecting = false; return; }
    final uri = Uri.parse('wss://ws.finnhub.io?token=$token');
    _channel = WebSocketChannel.connect(uri);
    _channel!.stream.listen(_onMessage, onError: _onError, onDone: _onDone);
    // resubscribe existing
    for (final s in _subs) { _send({'type':'subscribe','symbol': s}); }
    _connecting = false;
  }

  void setSubscriptions(Iterable<String> symbols) {
    final target = symbols.map((s) => s.toUpperCase().trim()).where((s) => s.isNotEmpty).toSet();
    final added = target.difference(_subs);
    final removed = _subs.difference(target);
    for (final s in added) { subscribe(s); }
    for (final s in removed) { unsubscribe(s); }
  }

  void subscribe(String symbol) {
    final sym = symbol.toUpperCase().trim();
    if (_subs.add(sym)) { _send({'type':'subscribe','symbol': sym}); }
  }

  void unsubscribe(String symbol) {
    final sym = symbol.toUpperCase().trim();
    if (_subs.remove(sym)) { _send({'type':'unsubscribe','symbol': sym}); }
  }

  void _send(Map<String, dynamic> msg)
  {
    debugPrint('send: $msg');
    _channel?.sink.add(jsonEncode(msg));
  }

  void _onMessage(dynamic data) {
    try {
      debugPrint('onMessage: $data');
      final m = jsonDecode(data as String) as Map<String, dynamic>;
      if (m['type'] == 'trade') {
        final arr = (m['data'] as List?) ?? const [];
        for (final t in arr) {
          final map = t as Map<String, dynamic>;
          final sym = (map['s'] as String);
          final p = (map['p'] as num).toDouble();
          final ts = DateTime.fromMillisecondsSinceEpoch((map['t'] as num).toInt());
          _tickCtl.add(PriceTick(sym, p, ts));
        }
      }
    } catch (_) { /* ignore malformed */ }
  }

  void _onError(Object e)
  {
    debugPrint('error: $e');
    _channel = null;
    Future.delayed(const Duration(seconds: 2), connect);
  }

  void _onDone() { _channel = null; Future.delayed(const Duration(seconds: 2), connect); }

  Future<void> dispose() async { await _tickCtl.close(); await _channel?.sink.close(); }
}

import 'dart:convert';

import 'package:flutter/foundation.dart' hide Summary;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:macos_ui/macos_ui.dart';



import 'summary.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig();
  await config.apply();
}

Future<void> main() async {
  if (!kIsWeb) {
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      await _configureMacosWindowUtils();
    }
  }

  runApp(const BigJsonApp());
}

class BigJsonApp extends StatelessWidget {
  const BigJsonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: 'Big JSON, Smooth UI',
      debugShowCheckedModeBanner: false,
      showPerformanceOverlay: false,
      theme: MacosThemeData.light(),
      darkTheme: MacosThemeData.dark(),
      themeMode: defaultTargetPlatform == TargetPlatform.macOS
        ? ThemeMode.system
        : ThemeMode.dark,
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  final _url = TextEditingController(text: '');
  bool _parseGenUsingCompute = false;
  bool _busy = false;
  String _status = 'Idle';
  int? _count;
  Duration? _elapsed;
  List<String> _samples = const [];
  String? _lastError;


  void showErrorDialog(BuildContext context, String message) {
    showMacosAlertDialog(
      context: context,
      builder: (_) => MacosAlertDialog(
        appIcon: const MacosIcon(
          CupertinoIcons.exclamationmark_triangle,
          size: 40,
          color: MacosColors.systemRedColor,
        ),
        title: const Text('Error'),
        message: Text(message),
        primaryButton: PushButton(
          controlSize: ControlSize.large, // <-- required
          child: const Text('OK'),
          onPressed: () => Navigator.of(context).pop(), // <-- enable button
        ),
      ),
    );
  }


  String generateJson() {
    setState(() {
      _busy = true;
      _status = 'Generating…';
      _lastError = null;
      _count = null;
      _elapsed = null;
      _samples = const [];
    });

    final sw = Stopwatch()
      ..start();

    String bigJson = "";
    try {
      const int count = 1000000;


      if(_parseGenUsingCompute) {
        showErrorDialog(context, "generate on compute not implemented yet");
      }
      else {
        bigJson = fakeExternalGenerateBigJson(count);
      }



      sw.stop();
      setState(() {
        _busy = false;
        _status = 'Done Generating';
        _elapsed = sw.elapsed;
      });


    } catch (e) {
      sw.stop();
      setState(() {
        _busy = false;
        _status = 'Error';
        _elapsed = sw.elapsed;
        _lastError = e.toString();
        throw StateError("load failed: $e");
      });
    }

    finally {
      return bigJson;
    }


  }

  // YOU WILL NEED TO UPDATE THIS METHOD TO BE ASYNC AWARE
  void parseJson({String? overrideRaw})  {
    final sw = Stopwatch()
      ..start();
    try {
      String raw;
      if (overrideRaw != null) {
        raw = overrideRaw;
      }
      else{
        raw = "";
      }

      setState(() {
        _busy = true;
        _status = 'Parsing…';
        _lastError = null;
        _count = null;
        _elapsed = null;
        _samples = const [];
      });

      final parsed;

      if(_parseGenUsingCompute) {
        showErrorDialog(context, "parse on compute not implemented yet");
        parsed = null;
      }
      else {
        parsed = fakeExternalParseJson(raw);
      }

      sw.stop();
      final summary = summarize(parsed);
      setState(() {
        _busy = false;
        _status = 'Done';
        _elapsed = sw.elapsed;
        _count = summary.itemCount;
        _samples = summary.samples;
      });
    } catch (e) {
      sw.stop();
      setState(() {
        _busy = false;
        _status = 'Error';
        _elapsed = sw.elapsed;
        _lastError = e.toString();
      });
    }
  }


  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text("Big JSON, Smooth UI"),
        titleWidth: 200,
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: PushButton(
                        onPressed: _busy
                            ? null
                            : () {
                                try {

                                    // YOU WILL NEED TO UPDATE THIS CODE TO BE ASYNC AWARE
                                    // SEE DOCUMENTATION ON 'THEN' FOR ORDERED TASKS
                                    // https://dart.dev/libraries/dart-async

                                    String rawJson = generateJson();
                                    parseJson(overrideRaw: rawJson);
                                } catch (e) {
                                  print(
                                      'Error during generation or parsing: $e');
                                }
                              },
                        controlSize: ControlSize.large,
                        child: const Text('Generate synthetic test data'),
                      ),
                    ),
                  ]),



                  const SizedBox(height: 8),
                  Row(children: [
                    const Expanded(
                      child: MacosTooltip(
                        message:
                            'Turn OFF to parse in on main thread (bad), turn ON to parse on isolate (good)',
                        child: Text("Parse on isolate (good)"),
                      ),
                    ),
                    MacosSwitch(
                      value: _parseGenUsingCompute,
                      onChanged: _busy
                          ? null
                          : (v) => setState(() => _parseGenUsingCompute = v),
                    ),
                  ]),


                  const SizedBox(height: 16),
                  Row(children: [
                    if (_busy)
                      const Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: SizedBox(
                            width: 24,
                            height: 24,
                            child: ProgressCircle(value: null,)),
                      ),
                    Text(_status),
                  ]),
                  if (_lastError != null) ...[
                    const SizedBox(height: 8),
                    Text(_lastError!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 12),
                  if (_elapsed != null)
                    Text('Elapsed: ${_elapsed!.inMilliseconds} ms'),
                  if (_count != null) ...[
                    Text('Items parsed: $_count'),
                    const Text('Samples:'),
                    ..._samples.map((s) => Text('• $s')),
                  ],

                ],
              ),
            );
          },
        ),
      ],
    );
  }


}


dynamic fakeExternalParseJson(String raw) {
  final decoded = jsonDecode(raw);
  if (decoded is List) {
    return decoded
        .map((e) => e is Map<String, dynamic> ? _project(e) : e)
        .toList(growable: false);
  } else if (decoded is Map<String, dynamic>) {
    if (decoded['data'] is List) {
      final list = (decoded['data'] as List)
          .map((e) => e is Map<String, dynamic> ? _project(e) : e)
          .toList(growable: false);
      return {'data': list};
    }
  }
  return decoded;
}

Map<String, dynamic> _project(Map<String, dynamic> m) {
  final out = <String, dynamic>{};
  for (final k in const ['id', 'name', 'title']) {
    if (m.containsKey(k)) out[k] = m[k];
  }
  out['checksum'] = _checksum(out);
  return out;
}

int _checksum(Map<String, dynamic> m) {
  final s = '${m['id'] ?? ''}|${m['name'] ?? ''}|${m['title'] ?? ''}';
  return s.codeUnits.fold(0, (a, b) => (a * 33 + b) & 0xFFFFFFFF);
}


Summary summarize(dynamic parsed) {
  if (parsed is List) {
    final count = parsed.length;
    final sampleLines = parsed.take(5).map((e) => _asLine(e)).toList();
    return Summary(count, sampleLines);
  } else if (parsed is Map && parsed['data'] is List) {
    final list = parsed['data'] as List;
    final sampleLines = list.take(5).map((e) => _asLine(e)).toList();
    return Summary(list.length, sampleLines);
  } else {
    return Summary(1, [_asLine(parsed)]);
  }
}

String _asLine(dynamic e) {
  if (e is Map) {
    final id = e['id'] ?? '';
    final name = e['name'] ?? e['title'] ?? '';
    return '{id: $id, name/title: $name}';
  }
  return e.toString();
}


String fakeExternalGenerateBigJson(int count) {
  final list = List.generate(
      count,
          (i) =>
      {
        'id': i + 1,
        'name': 'Item ${i + 1}',
        'title': 'Title ${i + 1}',
        'value': i * 3.14159,
        'flag': i % 2 == 0,
      });
  return jsonEncode(list);
}



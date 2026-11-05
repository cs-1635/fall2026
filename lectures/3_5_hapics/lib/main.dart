import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//Documentation: https://api.flutter.dev/flutter/services/HapticFeedback-class.html

void main() => runApp(const HapticsDemoApp());

class HapticsDemoApp extends StatelessWidget {
  const HapticsDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'iOS Haptics Demos',
      theme: ThemeData(useMaterial3: true),
      home: const _Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('iOS Haptics Demos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Basics'),
              Tab(text: 'Gestures'),
              Tab(text: 'Lists'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            _BasicImpacts(),
            _GesturePatterns(),
            _ListAndScroll(),
          ],
        ),
      ),
    );
  }
}

/// 1) Basic one-shot haptics via Flutter's services.
class _BasicImpacts extends StatelessWidget {
  const _BasicImpacts();

  Future<void> _do(Future<void> Function() fn) async {
    // Small debounce: avoid spamming the Taptic Engine.
    await fn();
    await Future<void>.delayed(const Duration(milliseconds: 80));
  }

  @override
  Widget build(BuildContext context) {
    final items = <_HItem>[
      _HItem('Light impact', () => HapticFeedback.lightImpact()),
      _HItem('Medium impact', () => HapticFeedback.mediumImpact()),
      _HItem('Heavy impact', () => HapticFeedback.heavyImpact()),
      _HItem('Selection click', () => HapticFeedback.selectionClick()),
      _HItem('Generic vibrate', () => HapticFeedback.vibrate()),
    ];

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final item = items[i];
        return FilledButton.tonal(
          onPressed: () => _do(item.run),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(item.label),
          ),
        );
      },
    );
  }
}

class _HItem {
  final String label;
  final Future<void> Function() run;
  _HItem(this.label, this.run);
}

/// 2) Gesture-driven haptics: progress/selection patterns.
class _GesturePatterns extends StatefulWidget {
  const _GesturePatterns();

  @override
  State<_GesturePatterns> createState() => _GesturePatternsState();
}

class _GesturePatternsState extends State<_GesturePatterns> {
  double _value = 0.0;
  int _lastStep = -1;

  // Fire a subtle click each time the slider crosses a 10% step.
  Future<void> _maybeTick(double v) async {
    final step = (v * 10).floor();
    if (step != _lastStep) {
      _lastStep = step;
      await HapticFeedback.selectionClick();
    }
  }

  // Provide a "commit" feel on release.
  Future<void> _commitTick() async {
    await HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Slider with step clicks (selection haptics)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Slider(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
              _maybeTick(v);
            },
            onChangeEnd: (_) => _commitTick(),
          ),
          const SizedBox(height: 32),
          const Text(
            'Long-press → heavy impact',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onLongPress: () async {
              await HapticFeedback.heavyImpact();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Long-press done')),
                );
              }
            },
            child: Container(
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Theme.of(context).colorScheme.outline),
              ),
              child: const Text('Press & Hold'),
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Drag threshold demo (light → medium → heavy)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _DragThresholdBox(),
        ],
      ),
    );
  }
}

class _DragThresholdBox extends StatefulWidget {
  const _DragThresholdBox();

  @override
  State<_DragThresholdBox> createState() => _DragThresholdBoxState();
}

class _DragThresholdBoxState extends State<_DragThresholdBox> {
  double _dx = 0;
  int _phase = 0;

  Future<void> _advancePhase(int p) async {
    if (p == _phase) return;
    _phase = p;
    switch (p) {
      case 1:
        await HapticFeedback.lightImpact();
        break;
      case 2:
        await HapticFeedback.mediumImpact();
        break;
      case 3:
        await HapticFeedback.heavyImpact();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (d) {
        setState(() => _dx += d.delta.dx);
        final abs = _dx.abs();
        if (abs > 200) {
          _advancePhase(3);
        } else if (abs > 100) {
          _advancePhase(2);
        } else if (abs > 20) {
          _advancePhase(1);
        } else {
          _advancePhase(0);
        }
      },
      onPanEnd: (_) async {
        setState(() => _dx = 0);
        _advancePhase(0);
        await HapticFeedback.selectionClick(); // reset feel
      },
      child: Container(
        height: 80,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: const Text('Drag left/right past thresholds'),
      ),
    );
  }
}

/// 3) List/scroll ergonomics: selection clicks & overscroll "edge" pop.
class _ListAndScroll extends StatelessWidget {
  const _ListAndScroll();

  Future<void> _edgePop(ScrollNotification n) async {
    // On iOS, bouncing near edges feels nicer with a small impact.
    if (n.metrics.atEdge && n is OverscrollNotification) {
      await HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (n) {
        _edgePop(n);
        return false;
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 20,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          return ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
            ),
            title: Text('Row $i'),
            subtitle: const Text('Tap to get a selection haptic'),
            onTap: () async => HapticFeedback.selectionClick(),
            trailing: IconButton(
              onPressed: () async => HapticFeedback.lightImpact(),
              icon: const Icon(Icons.more_horiz),
              tooltip: 'Light impact',
            ),
          );
        },
      ),
    );
  }
}
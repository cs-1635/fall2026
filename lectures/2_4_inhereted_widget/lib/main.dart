import 'package:flutter/material.dart';
import 'my_data.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('MyApp.build');
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'InheritedWidget Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),
      home: const DemoPage(),
    );
  }
}

/// Hosts the `MyData` ancestor and owns the mutable counter state.
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  int _value = 0;

  void _inc() {
    setState(() => _value++);
    debugPrint('DemoPage: increment -> $_value');
  }

  void _dec() {
    setState(() => _value--);
    debugPrint('DemoPage: decrement -> $_value');
  }

  void _same() {
    setState(() => _value = _value);
    debugPrint('DemoPage: set same value ($_value) – expect NO listener rebuilds');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Set the same value – listeners should not rebuild'),
          duration: Duration(milliseconds: 900),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('DemoPage.build (hosting MyData with value=$_value)');
    return MyData(
      value: _value,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('InheritedWidget Demo'),
          actions: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'App value: $_value',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            ControlButtons(),
            SizedBox(height: 16),
            SectionHeader('Listening widget (uses MyData.of)'),
            ListeningPanel(),
            Divider(height: 32),
            SectionHeader('Non-listening widget (does NOT read MyData)'),
            NonListeningPanel(),
            SizedBox(height: 12),
            SectionHeader('Read-once (reads without subscribing)'),
            ReadOncePanel(),
            Divider(height: 32),
            SectionHeader('Deeply nested example (listener far below)'),
            DeepTree(),
            Divider(height: 32),
            SectionHeader('Const island (does not rebuild on parent setState)'),
            StaticIsland(),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.findAncestorStateOfType<_DemoPageState>()!;
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: state._dec,
          icon: const Icon(Icons.remove),
          label: const Text('Decrement'),
        ),
        const SizedBox(width: 8),
        ElevatedButton.icon(
          onPressed: state._inc,
          icon: const Icon(Icons.add),
          label: const Text('Increment'),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: state._same,
          child: const Text('Set same value'),
        ),
      ],
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String text;
  const SectionHeader(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

/// Reads the inherited value; rebuilds when MyData.value changes.
class ListeningPanel extends StatelessWidget {
  const ListeningPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final inherited = MyData.of(context)!; // registers as dependent
    debugPrint('ListeningPanel.build (value=${inherited.value})');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _RebuildCounter(label: 'ListeningPanel'),
            Text('Inherited value: ${inherited.value}', style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

/// Does not call MyData.of(context); not a dependent of the inherited widget.
class NonListeningPanel extends StatelessWidget {
  const NonListeningPanel({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('NonListeningPanel.build');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            _RebuildCounter(label: 'NonListeningPanel'),
            Text('Static content (does not read MyData)'),
          ],
        ),
      ),
    );
  }
}

/// Reads MyData WITHOUT establishing a dependency.
class ReadOncePanel extends StatelessWidget {
  const ReadOncePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final snapshot = MyData.maybeRead(context)?.value;
    debugPrint('ReadOncePanel.build (snapshot=$snapshot)');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _RebuildCounter(label: 'ReadOncePanel'),
            Text('Read-once snapshot: $snapshot'),
          ],
        ),
      ),
    );
  }
}

/// Deeper tree with a listener far below the ancestor.
class DeepTree extends StatelessWidget {
  const DeepTree({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('DeepTree.build');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [LevelA()],
    );
  }
}

class LevelA extends StatelessWidget {
  const LevelA({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('LevelA.build');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: const LevelB(),
    );
  }
}

class LevelB extends StatelessWidget {
  const LevelB({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('LevelB.build');
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: const LevelC(),
    );
  }
}

class LevelC extends StatelessWidget {
  const LevelC({super.key});

  @override
  Widget build(BuildContext context) {
    final v = MyData.of(context)!.value;
    debugPrint('LevelC.build (value=$v)');
    return Card(
      color: Colors.indigo.withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _RebuildCounter(label: 'LevelC (listener)'),
            Text('Deep listener sees: $v'),
          ],
        ),
      ),
    );
  }
}

/// A fully-const island that will not rebuild on parent setState.
class StaticIsland extends StatelessWidget {
  const StaticIsland({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('StaticIsland.build'); // Will print once
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.anchor, size: 18),
            SizedBox(width: 8),
            Text('Const subtree: does not rebuild on parent setState'),
          ],
        ),
      ),
    );
  }
}

/// Utility widget that increments a visible counter every time it rebuilds.
class _RebuildCounter extends StatefulWidget {
  final String label;
  const _RebuildCounter({required this.label, super.key});

  @override
  State<_RebuildCounter> createState() => _RebuildCounterState();
}

class _RebuildCounterState extends State<_RebuildCounter> {
  int _builds = 0;

  @override
  Widget build(BuildContext context) {
    _builds += 1;
    return Row(
      children: [
        const Icon(Icons.loop, size: 16),
        const SizedBox(width: 6),
        Text('${widget.label}: builds = $_builds'),
      ],
    );
  }
}
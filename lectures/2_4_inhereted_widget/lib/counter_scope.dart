import 'package:flutter/widgets.dart';

/// Makes [count] available to descendants of this widget.
class CounterScope extends InheritedWidget {
  const CounterScope({
    required this.count,
    required super.child,
    super.key,
  });

  final int count;

  /// Reading through this method registers [context] as a dependent.
  static CounterScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CounterScope>();
    assert(scope != null, 'No CounterScope found above this widget');
    return scope!;
  }

  @override
  bool updateShouldNotify(CounterScope oldWidget) => count != oldWidget.count;
}

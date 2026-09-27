import 'package:flutter/widgets.dart';

/// InheritedWidget carrying an integer [value].
///
/// - Use [MyData.of(context)] to read and *subscribe* (widget rebuilds when
///   [value] changes).
/// - Use [MyData.maybeRead(context)] to read *without* subscribing
///   (widget does not rebuild when [value] changes).
class MyData extends InheritedWidget {
  final int value;

  const MyData({
    required this.value,
    required Widget child,
    super.key,
  }) : super(child: child);

  /// Registers the caller as a dependent (will rebuild when [value] changes).
  static MyData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MyData>();
  }

  /// Reads without establishing a dependency (no rebuild on [value] change).
  static MyData? maybeRead(BuildContext context) {
    final element = context.getElementForInheritedWidgetOfExactType<MyData>();
    return element?.widget is MyData ? element!.widget as MyData : null;
  }

  @override
  bool updateShouldNotify(covariant MyData oldWidget) => value != oldWidget.value;
}
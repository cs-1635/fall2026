import 'dart:convert';

/// Generates a large JSON string with [count] items. Each item has predictable keys.
dynamic generateBigJson({int count = 1200000}) {
  final list = List.generate(count, (i) => {
        'id': i + 1,
        'name': 'Item ${i + 1}',
        'title': 'Title ${i + 1}',
        'value': i * 3.14159,
        'flag': i % 2 == 0,
      });
  return jsonEncode(list);
}

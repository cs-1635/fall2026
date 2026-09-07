import 'package:flutter/foundation.dart';

// Must be top-level and synchronous.
List<int> findPrimesUpTo(int max) {
  final primes = <int>[];
  for (var n = 2; n <= max; n++) {
    var isPrime = true;
    for (var d = 2; d * d <= n; d++) {
      if (n % d == 0) {
        isPrime = false;
        break;
      }
    }
    if (isPrime) primes.add(n);
  }
  return primes;
}

// Call this from your UI
Future<void> runPrimesDemo() async {
  // Offload heavy loop to background isolate
  final primes = await compute(findPrimesUpTo, 100000); // find primes ≤ 100000
  debugPrint('Found ${primes.length} primes. First 5: ${primes.take(5).toList()}');
}
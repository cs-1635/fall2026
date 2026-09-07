import 'package:flutter/material.dart';
import 'compute_primes_demo.dart'; // or your compute demo

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compute Demo',
      home: const MyPage(), // your widget that uses Scaffold
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compute Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: runPrimesDemo, // or runImageDemo/runParseDemo
          child: const Text('Run compute'),
        ),
      ),
    );
  }
}
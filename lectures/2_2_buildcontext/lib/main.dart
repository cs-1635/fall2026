import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super. key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login UI',
      theme: ThemeData(primarySwatch: Colors.purple),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: MaterialButton(
            color: Colors.white,
            child: Text("Tap me!"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Snackbar")),
              );
            },
          ), //Material Button
        ), //Center
      ), //Scaffold
    );
  }
}
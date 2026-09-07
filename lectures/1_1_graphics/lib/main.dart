import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'CS 1635 Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CS 1635'),
      ),
      body: ListView(children: <Widget>[
        SizedBox(
          width: 400,
          height: 400,
          child: CustomPaint(
            painter: MyPainter(),
          ),
        ),
      ]),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(100 , 100), 100, paint1);


    var paint2 = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(const Offset(200, 200), 80, paint2);
    canvas.drawCircle(const Offset(200, 200), 60, paint1);

    canvas.drawCircle(const Offset(200, 200), 40, paint2);
    canvas.drawCircle(const Offset(200, 200), 20, paint1);


  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
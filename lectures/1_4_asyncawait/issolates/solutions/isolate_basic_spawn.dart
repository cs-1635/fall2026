
import 'dart:isolate';

Future<void> runExample() async {
  final done = ReceivePort();

  await Isolate.spawn(_runWorker, {'reply': done.sendPort, 'msg': 'hello from main'});

  await for (final msg in done) {
    if (msg == 'done') {
      print('main: got done');
      done.close();
    }
  }
}

void _runWorker(Map data) {
  final SendPort reply = data['reply'];
  final String msg = data['msg'];
  print('worker: $msg');
  reply.send('done');
}

void main(List<String> args) async {
  runExample();
}

import 'dart:isolate';

Future<void> runExample() async {
  final mainPort = ReceivePort();
  await Isolate.spawn(_worker, mainPort.sendPort);

  SendPort? toWorker;
  await for (final msg in mainPort) {
    if (msg is SendPort) {
      toWorker = msg;
      toWorker!.send('ping');
    } else if (msg is String && msg == 'pong') {
      print('main: got pong');
      mainPort.close();
      break;
    }
  }
}

void _worker(SendPort toMain) {
  final workerPort = ReceivePort();
  toMain.send(workerPort.sendPort);

  workerPort.listen((message) {
    if (message == 'ping') {
      print('worker: got ping');
      toMain.send('pong');
      workerPort.close();
    }
  });
}

void main(List<String> args) async {
  runExample();
}

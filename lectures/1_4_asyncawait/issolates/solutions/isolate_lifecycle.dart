import 'dart:isolate';

Future<void> runExample() async {
  final msgPort = ReceivePort();
  final errPort = ReceivePort();
  final exitPort = ReceivePort();

  final iso = await Isolate.spawn(_worker, msgPort.sendPort);
  iso.addErrorListener(errPort.sendPort);
  iso.addOnExitListener(exitPort.sendPort);

  await for (final msg in msgPort) {
    print('main: message => $msg');
    break; // got first message
  }

  // Expect an error next
  final errorData = await errPort.first; // [error, stackTrace]
  print('main: error => $errorData');

  // Kill isolate
  iso.kill(priority: Isolate.immediate);

  // Wait for exit signal
  await exitPort.first;
  print('main: worker exited');

  msgPort.close();
  errPort.close();
  exitPort.close();
}

void _worker(SendPort toMain) {
  toMain.send('hello from worker');
  // Deliberately throw
  throw StateError('boom');
}

void main(List<String> args) async {
  runExample();
}
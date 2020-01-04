import 'dart:isolate';

typedef UserFunction = Function(dynamic params, CallbackFunction onDataChanged);
typedef CallbackFunction = void Function(dynamic params);
class SimpleThread {
  CallbackFunction _onDataChanged;
  ReceivePort _spawnerReceiver;
  SendPort _threadReceiver;

  SimpleThread(this._onDataChanged) {
    _spawnerReceiver = ReceivePort();
    Isolate.spawn(_execute, _spawnerReceiver.sendPort);
    _spawnerReceiver.listen((msg){
      if (msg != null) {
        if (_threadReceiver == null) {
          _threadReceiver = msg["threadReceiver"];         
        } else {
          var newData = msg["onDataChanged"];
          if (newData != null && _onDataChanged != null) {
            _onDataChanged(newData);
          }
        }
      }
    });
  }

  execute(UserFunction func, dynamic params, CallbackFunction onDataChanged) {
    _onDataChanged = onDataChanged;
    if (_threadReceiver != null) {
      _threadReceiver.send({"func": func, "params": params});
    }
  }

  static void _execute(SendPort spawnerPort) {
    final threadReceiver = ReceivePort();
    spawnerPort.send({"threadReceiver": threadReceiver.sendPort});
    threadReceiver.listen((msg){
      if (msg != null) {
        UserFunction func = msg["func"];
        dynamic params = msg["params"];
        if (func != null) {
          func(params, (newData){
            spawnerPort.send({"onDataChanged": newData});
          });
        }
      }
    });
  }
  close(){
    _spawnerReceiver.close();
  }
}
import 'dart:async';

class Dbouncer {
  final int milliseconds;
  Timer? timer;
  Dbouncer({this.milliseconds = 3000});

  call(Function() callback) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), callback);
  }
}

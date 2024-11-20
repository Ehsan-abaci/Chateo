import 'package:flutter/foundation.dart' show immutable;

typedef CloseErrorScreen = bool Function();
typedef UpdateErrorScreen = bool Function(List<String> text);

@immutable
class ErrorScreenController {
  final CloseErrorScreen close;
  final UpdateErrorScreen update;

  const ErrorScreenController({
    required this.close,
    required this.update,
  });
}

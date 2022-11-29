import 'package:flutter/foundation.dart' show immutable;

typedef CloseLoadingScreen = bool Function();
typedef UpdatelodingScreen = bool Function(String text);

@immutable
class LoadingScreenContrller {
  final CloseLoadingScreen close;
  final UpdatelodingScreen update;

  const LoadingScreenContrller({
    required this.close,
    required this.update,
  });
}

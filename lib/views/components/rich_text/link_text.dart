import 'package:flutter/foundation.dart' show immutable, VoidCallback;
import 'package:instatgram/views/components/rich_text/base_text.dart';

@immutable
class LinkText extends BaseText {
  final VoidCallback onTapped;

  LinkText({
    required this.onTapped,
    required super.text,
    super.style,
  });
}

import 'dart:collection' show MapView;
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import '../../posts/typedef/user_id.dart';

@immutable
class UserInfoPayload extends MapView<String, String> {
  UserInfoPayload({
    required UserId userId,
    required String? email,
    required String? displayName,
  }) : super({
          FirebaseFiledName.userId: userId,
          FirebaseFiledName.email: email ?? '',
          FirebaseFiledName.displayName: displayName ?? '',
        });
}

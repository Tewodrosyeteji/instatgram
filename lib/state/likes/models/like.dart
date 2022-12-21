import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';

@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likedBy,
    required DateTime date,
  }) : super(
          {
            FirebaseFiledName.postId: postId,
            FirebaseFiledName.userId: likedBy,
            FirebaseFiledName.date: date.toIso8601String(),
          },
        );
}

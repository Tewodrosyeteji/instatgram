import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';

@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) : super({
          FirebaseFiledName.userId: fromUserId,
          FirebaseFiledName.postId: onPostId,
          FirebaseFiledName.comment: comment,
          FirebaseFiledName.createdAt: FieldValue.serverTimestamp(),
        });
}

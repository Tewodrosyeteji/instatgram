import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/comments/typedefs/comment_id.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';

@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId;
  final PostId onPostID;

  Comment(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFiledName.comment],
        createdAt = (json[FirebaseFiledName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFiledName.userId],
        onPostID = json[FirebaseFiledName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          fromUserId == other.fromUserId &&
          onPostID == other.onPostID;

  @override
  int get hashCode => Object.hashAll([
        id,
        comment,
        createdAt,
        fromUserId,
        onPostID,
      ]);
}

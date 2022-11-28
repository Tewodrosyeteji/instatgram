import 'package:flutter/foundation.dart' show immutable;

@immutable
class FirebaseCollectionName {
  static const thumbnails = 'thumbnails';
  static const comments = 'comments';
  static const users = 'users';
  static const posts = 'posts';
  static const likes = 'likes';
  const FirebaseCollectionName._();
}

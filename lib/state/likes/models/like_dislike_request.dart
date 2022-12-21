import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/state/posts/typedef/user_id.dart';

import '../../posts/typedef/post_id.dart';

@immutable
class LikeDislikeRequest {
  final UserId likedBy;
  final PostId postId;

  const LikeDislikeRequest({
    required this.likedBy,
    required this.postId,
  });
}

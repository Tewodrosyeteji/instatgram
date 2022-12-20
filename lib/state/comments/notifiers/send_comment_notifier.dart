import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/models/comment_payload.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/image_upload/typedefs/is_loading.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';
import 'package:instatgram/state/posts/typedef/user_id.dart';

class SendCommentNotifier extends StateNotifier<Isloading> {
  SendCommentNotifier() : super(false);

  set isLoading(bool value) => state = value;
  Future<bool> sendComment({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) async {
    isLoading = true;

    final payload = CommentPayload(
      fromUserId: fromUserId,
      onPostId: onPostId,
      comment: comment,
    );
    try {
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .add(payload);

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}

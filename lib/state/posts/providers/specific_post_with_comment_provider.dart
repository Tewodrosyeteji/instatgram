import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/extensions/comment_sorted_by_request.dart';
import 'package:instatgram/state/comments/models/comment.dart';
import 'package:instatgram/state/comments/models/post_comments_reqest.dart';
import 'package:instatgram/state/comments/models/post_with_comments.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/models/post.dart';

final specificPostWithCommentProvider = StreamProvider.family
    .autoDispose<PostWithComment, RequestForPostAndComments>(
  ((ref, RequestForPostAndComments request) {
    final controller = StreamController<PostWithComment>();

    Post? post;
    Iterable<Comment>? comments;

    void notify() {
      final localPost = post;
      if (localPost == null) {
        return;
      }

      final outputComment = (comments ?? []).applySortingFrom(
        request,
      );

      final result = PostWithComment(
        post: localPost,
        comments: outputComment,
      );

      controller.sink.add(result);
    }

    final postSub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .where(
          FieldPath.documentId,
          isEqualTo: request.postId,
        )
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        if (snapshot.docs.isEmpty) {
          post = null;
          comments = null;
          notify();
          return;
        }

        final doc = snapshot.docs.first;
        if (doc.metadata.hasPendingWrites) {
          return;
        }

        post = Post(
          postId: doc.id,
          json: doc.data(),
        );
        notify();
      },
    );

    final commentQuery = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(
          FirebaseFiledName.postId,
          isEqualTo: request.postId,
        )
        .orderBy(
          FirebaseFiledName.createdAt,
          descending: true,
        );

    final limitedCommentsQuery = request.limit != null
        ? commentQuery.limit(request.limit!)
        : commentQuery;

    final commentSub = limitedCommentsQuery.snapshots().listen(
      (snapshot) {
        comments = snapshot.docs
            .where((doc) => !doc.metadata.hasPendingWrites)
            .map(
              (doc) => Comment(
                doc.data(),
                id: doc.id,
              ),
            )
            .toList();
        notify();
      },
    );

    ref.onDispose(() {
      commentSub.cancel();
      postSub.cancel();
      controller.close();
    });
    return controller.stream;
  }),
);

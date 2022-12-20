import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/comments/extensions/comment_sorted_by_request.dart';
import 'package:instatgram/state/comments/models/comment.dart';
import 'package:instatgram/state/comments/models/post_comments_reqest.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';

final postCommentProvider = StreamProvider.family
    .autoDispose<Iterable<Comment>, RequestForPostAndComments>(
  ((
    ref,
    RequestForPostAndComments request,
  ) {
    final controller = StreamController<Iterable<Comment>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.comments)
        .where(
          FirebaseFiledName.postId,
          isEqualTo: request.postId,
        )
        .snapshots()
        .listen((snapshot) {
      final documents = snapshot.docs;
      final limitedDocuments =
          request.limit != null ? documents.take(request.limit!) : documents;

      final comments = limitedDocuments
          .where(
            (doc) => !doc.metadata.hasPendingWrites,
          )
          .map((document) => Comment(
                document.data(),
                id: document.id,
              ));

      final result = comments.applySortingFrom(request);
      controller.sink.add(result);
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });
    return controller.stream;
  }),
);

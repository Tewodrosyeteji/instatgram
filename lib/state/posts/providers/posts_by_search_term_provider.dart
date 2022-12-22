import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/models/post.dart';
import 'package:instatgram/state/posts/typedef/search_term.dart';

final postsBySearchTermProvidee =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>(
  ((ref, SearchTerm searchTerm) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.posts)
        .orderBy(
          FirebaseFiledName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen((snapshot) {
      final posts = snapshot.docs
          .map(
            (doc) => Post(
              postId: doc.id,
              json: doc.data(),
            ),
          )
          .where(
            (post) => post.message.toLowerCase().contains(
                  searchTerm.toLowerCase(),
                ),
          );
      controller.sink.add(posts);
    });
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  }),
);

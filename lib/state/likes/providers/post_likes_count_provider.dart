import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/constants/firebase_collection_name.dart';
import 'package:instatgram/state/constants/firebase_fileld_name.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';

final postLikesCountProvider = StreamProvider.family.autoDispose<int, PostId>(
  ((
    ref,
    PostId postId,
  ) {
    final controller = StreamController<int>.broadcast();
    controller.onListen = () {
      controller.sink.add(0);
    };

    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.likes)
        .where(FirebaseFiledName.postId, isEqualTo: postId)
        .snapshots()
        .listen((snapshot) {
      controller.sink.add(
        snapshot.docs.length,
      );
    });

    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  }),
);

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/likes/providers/post_likes_count_provider.dart';
import 'package:instatgram/state/posts/typedef/post_id.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/animations/small_error_animation_view.dart';
import 'package:instatgram/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(
      postLikesCountProvider(
        postId,
      ),
    );
    return likesCount.when(
      data: ((int likesCount) {
        final personOrPeople =
            likesCount == 1 ? Strings.person : Strings.people;
        final likesText = '$likesCount $personOrPeople ${Strings.likedThis}';
        return Text(
          likesText,
        );
      }),
      error: ((error, stackTrace) {
        return const SmallErrorAnimationView();
      }),
      loading: (() {
        return const LoadingAnimationView();
      }),
    );
  }
}
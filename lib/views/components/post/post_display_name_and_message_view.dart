import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/user_id_provider.dart';
import 'package:instatgram/state/posts/models/post.dart';
import 'package:instatgram/state/user_info/providers/user_info_model_provider.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/animations/small_error_animation_view.dart';
import 'package:instatgram/views/components/rich_two_parts_text.dart';

class PostDisplayNameAndMessageView extends ConsumerWidget {
  final Post post;
  const PostDisplayNameAndMessageView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdInfo = ref.watch(
      userInfoModelProvider(
        post.userId,
      ),
    );
    return userIdInfo.when(
      data: ((userInfo) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: RichTwoPartstext(
            leftPart: userInfo.displayName,
            rightPart: post.message,
          ),
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

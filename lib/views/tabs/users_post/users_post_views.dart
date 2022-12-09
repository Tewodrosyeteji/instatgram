import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/posts/providers/user_post_provider.dart';
import 'package:instatgram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instatgram/views/components/animations/error_animation_view.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/post/posts_grid_view.dart';
import 'package:instatgram/views/constants/strings.dart';

class UsersPostViews extends ConsumerWidget {
  const UsersPostViews({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(UserPostProvider);

    return RefreshIndicator(
      onRefresh: (() {
        ref.refresh(UserPostProvider);
        return Future.delayed(const Duration(seconds: 1));
      }),
      child: posts.when(
        data: ((posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
                text: Strings.youHaveNoPosts);
          } else {
            return PostsGridView(posts: posts);
          }
        }),
        error: ((error, stackTrace) {
          return const ErrorAnimationView();
        }),
        loading: (() {
          return const LoadingAnimationView();
        }),
      ),
    );
  }
}

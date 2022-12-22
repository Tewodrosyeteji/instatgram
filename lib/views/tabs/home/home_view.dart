import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/posts/providers/all_posts_provier.dart';
import 'package:instatgram/views/components/animations/empty_contents_with_text_animation_view.dart';
import 'package:instatgram/views/components/animations/error_animation_view.dart';
import 'package:instatgram/views/components/animations/loading_animation_view.dart';
import 'package:instatgram/views/components/post/posts_grid_view.dart';
import 'package:instatgram/views/constants/strings.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(allPostsProvider);

    return RefreshIndicator(
      onRefresh: (() {
        ref.refresh(allPostsProvider);
        return Future.delayed(
          const Duration(seconds: 1),
        );
      }),
      child: posts.when(
        data: ((posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithTextAnimationView(
                text: Strings.noPostsAvailable);
          } else {
            return PostsGridView(
              posts: posts,
            );
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

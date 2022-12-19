import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/auth_state_provider.dart';
import 'package:instatgram/state/image_upload/providers/image_uploader_provider.dart';

final isLoadingProvider = Provider<bool>(
  ((ref) {
    final authState = ref.watch(authStateProvider);
    final isUploadingImage = ref.watch(imageUplaoderProvider);
    return authState.isLoading || isUploadingImage;
  }),
);

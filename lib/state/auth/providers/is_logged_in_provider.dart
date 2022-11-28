import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/auth_state_provider.dart';
import 'package:instatgram/state/models/auth_result.dart';

final isLoogedInProvider = Provider<bool>(
  ((ref) {
    final authState = ref.watch(authStateProvider);
    return authState.result == AuthResult.sucess;
  }),
);

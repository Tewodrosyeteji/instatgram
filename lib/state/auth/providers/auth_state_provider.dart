import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/notifier/auth_state-notifier.dart';
import '../../models/auth_state.dart';

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
    (_) => AuthStateNotifier());

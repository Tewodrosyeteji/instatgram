import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/post_settings/models/post_setting.dart';
import 'package:instatgram/state/post_settings/notifier/post_settings_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettigNotifier, Map<PostSetting, bool>>(
  ((ref) => PostSettigNotifier()),
);

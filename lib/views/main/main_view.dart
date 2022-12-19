import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/auth_state_provider.dart';
import 'package:instatgram/state/image_upload/helpers/image_picker_helper.dart';
import 'package:instatgram/state/image_upload/models/file_type.dart';
import 'package:instatgram/state/post_settings/providers/post_settings_provider.dart';
import 'package:instatgram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instatgram/views/components/dialogs/logout_dialog_model.dart';
import 'package:instatgram/views/create_new/create_new_post_view.dart';
import 'package:instatgram/views/tabs/users_post/users_post_views.dart';

import '../constants/strings.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.appName),
          actions: [
            IconButton(
              onPressed: (() async {
                final videoFile =
                    await ImagePickerHelper.pickVideoFromGallery();
                if (videoFile == null) {
                  return;
                }
                ref.refresh(postSettingProvider);
                if (!mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((_) => CreateNewPost(
                          fileToPost: videoFile,
                          fileType: FileType.video,
                        )),
                  ),
                );
              }),
              icon: const FaIcon(FontAwesomeIcons.film),
            ),
            IconButton(
              onPressed: (() async {
                final imageFile =
                    await ImagePickerHelper.pickImageFromGallery();
                if (imageFile == null) {
                  return;
                }
                ref.refresh(postSettingProvider);
                if (!mounted) {
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((_) => CreateNewPost(
                          fileToPost: imageFile,
                          fileType: FileType.image,
                        )),
                  ),
                );
              }),
              icon: const Icon(Icons.add_photo_alternate_outlined),
            ),
            IconButton(
              onPressed: (() async {
                final shouldLogOut = await const LogoutDialog()
                    .present(context)
                    .then((value) => value ?? false);
                if (shouldLogOut) {
                  await ref.read(authStateProvider.notifier).logOut();
                }
              }),
              icon: const Icon(Icons.logout),
            )
          ],
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.people),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.home),
            ),
          ]),
        ),
        body: const TabBarView(children: [
          UsersPostViews(),
          UsersPostViews(),
          UsersPostViews(),
        ]),
      ),
    );
  }
}

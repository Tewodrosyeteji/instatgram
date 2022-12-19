import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instatgram/state/auth/providers/user_id_provider.dart';
import 'package:instatgram/state/image_upload/models/file_type.dart';
import 'package:instatgram/state/image_upload/models/thumbnail_request.dart';
import 'package:instatgram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:instatgram/state/post_settings/models/post_setting.dart';
import 'package:instatgram/state/post_settings/providers/post_settings_provider.dart';
import 'package:instatgram/views/components/file_thumbnail_view.dart';
import 'package:instatgram/views/constants/strings.dart';

class CreateNewPost extends StatefulHookConsumerWidget {
  final File fileToPost;
  final FileType fileType;
  const CreateNewPost({
    required this.fileToPost,
    required this.fileType,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateNewPostState();
}

class _CreateNewPostState extends ConsumerState<CreateNewPost> {
  @override
  Widget build(BuildContext context) {
    final thumbnailRequest = ThumbnailRequest(
      file: widget.fileToPost,
      fileType: widget.fileType,
    );
    final postSetting = ref.watch(postSettingProvider);
    final postController = useTextEditingController();
    final isPostButtonEnabled = useState(false);
    useEffect((() {
      void listener() {
        isPostButtonEnabled.value = postController.text.isNotEmpty;
      }

      postController.addListener(listener);
      return (() {
        postController.removeListener(listener);
      });
    }), [postController]);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          Strings.createNewPost,
        ),
        actions: [
          IconButton(
            onPressed: isPostButtonEnabled.value
                ? () async {
                    final userId = ref.watch(userIdProvider);
                    if (userId == null) {
                      return;
                    }
                    final message = postController.text;
                    final isUpload =
                        await ref.read(imageUplaoderProvider.notifier).upload(
                              file: widget.fileToPost,
                              fileType: widget.fileType,
                              message: message,
                              userId: userId,
                              postSetting: postSetting,
                            );
                    if (isUpload && mounted) {
                      Navigator.of(context).pop();
                    }
                  }
                : null,
            icon: const Icon(Icons.send),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FileThumbnailView(
              thumbnailRequest: thumbnailRequest,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: Strings.pleaseWriteYourMessageHere,
                ),
                autofocus: true,
                maxLines: null,
                controller: postController,
              ),
            ),
            ...PostSetting.values.map(
              ((postSet) => ListTile(
                    title: Text(postSet.title),
                    subtitle: Text(postSet.description),
                    trailing: Switch(
                      value: postSetting[postSet] ?? false,
                      onChanged: ((isOn) {
                        ref
                            .read(postSettingProvider.notifier)
                            .setSetting(postSet, isOn);
                      }),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

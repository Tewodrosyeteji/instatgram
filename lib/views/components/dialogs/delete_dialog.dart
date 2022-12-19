import 'package:flutter/foundation.dart' show immutable;
import 'package:instatgram/views/components/constants/strings.dart';
import 'package:instatgram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({required titleOfObjectTODelete})
      : super(
          title: '{$Strings.delete} $titleOfObjectTODelete',
          message:
              '{$Strings.areYouSureYouWentTODeleteThis} $titleOfObjectTODelete',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}

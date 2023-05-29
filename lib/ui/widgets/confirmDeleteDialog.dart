import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  const ConfirmDeleteDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        CupertinoButton(
            child: Text(
              UiUtils.getTranslatedLabel(context, yesKey),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        CupertinoButton(
            child: Text(
              UiUtils.getTranslatedLabel(context, noKey),
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
      content: Text(UiUtils.getTranslatedLabel(context, areYouSureToDeleteKey)),
    );
  }
}

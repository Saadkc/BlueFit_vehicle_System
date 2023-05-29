import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class DismissibleBackgroundContainer extends StatelessWidget {
  const DismissibleBackgroundContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            Icons.edit,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            UiUtils.getTranslatedLabel(context, editKey),
            style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onPrimary),
    );
  }
}

import 'package:eschool_teacher/ui/widgets/customCloseButton.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class BottomSheetTopBarMenu extends StatelessWidget {
  final String title;
  final Function onTapCloseButton;
  const BottomSheetTopBarMenu(
      {Key? key, required this.onTapCloseButton, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(UiUtils.bottomSheetHorizontalContentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w600),
              ),
              Spacer(),
              CustomCloseButton(onTapCloseButton: () {
                onTapCloseButton();
              }),
            ],
          ),
          Divider(
            height: 20,
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

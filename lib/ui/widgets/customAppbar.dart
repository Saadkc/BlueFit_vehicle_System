import 'package:eschool_teacher/ui/widgets/customBackButton.dart';
import 'package:eschool_teacher/ui/widgets/screenTopBackgroundContainer.dart';

import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final Function? onPressBackButton;
  final String? subTitle;
  final Widget? trailingWidget;
  final bool? showBackButton;
  CustomAppBar(
      {Key? key,
      this.onPressBackButton,
      this.showBackButton,
      required this.title,
      this.subTitle,
      this.trailingWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.all(0),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          children: [
            (showBackButton ?? true)
                ? CustomBackButton(
                    onTap: onPressBackButton,
                    alignmentDirectional: AlignmentDirectional.centerStart,
                  )
                : SizedBox(),
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Padding(
                  child: trailingWidget,
                  padding: EdgeInsetsDirectional.only(
                    end: UiUtils.screenContentHorizontalPadding,
                  )),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                width: boxConstraints.maxWidth * (0.6),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: UiUtils.screenTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                alignment: Alignment.center,
                width: boxConstraints.maxWidth * (0.6),
                margin: EdgeInsets.only(
                    top: boxConstraints.maxHeight * (0.25) +
                        UiUtils.screenTitleFontSize),
                child: Text(
                  subTitle ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: UiUtils.screenSubTitleFontSize,
                      color: Theme.of(context).scaffoldBackgroundColor),
                ),
              ),
            ),
          ],
        );
      }),
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
    );
  }
}

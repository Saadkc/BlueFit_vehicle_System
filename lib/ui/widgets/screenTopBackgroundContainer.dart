import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class ScreenTopBackgroundContainer extends StatelessWidget {
  final Widget? child;
  final double? heightPercentage;
  final EdgeInsets? padding;
  const ScreenTopBackgroundContainer(
      {Key? key, this.child, this.heightPercentage, this.padding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          EdgeInsets.only(
              top: MediaQuery.of(context).padding.top +
                  UiUtils.screenContentTopPadding),
      alignment: Alignment.topCenter,
      child: child,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height *
          (heightPercentage ?? UiUtils.appBarBiggerHeightPercentage),
      decoration: BoxDecoration(
          color: UiUtils.getColorScheme(context).primary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25))),
    );
  }
}

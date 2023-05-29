import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class DefaultDropDownLabelContainer extends StatelessWidget {
  final double? height;
  final double width;
  final double? radius;
  final String titleLabelKey;
  final EdgeInsetsGeometry? margin;
  const DefaultDropDownLabelContainer(
      {Key? key,
      required this.titleLabelKey,
      this.height,
      required this.width,
      this.radius,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? EdgeInsets.only(bottom: (20)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: AlignmentDirectional.centerStart,
      child: Text(UiUtils.getTranslatedLabel(context, titleLabelKey),
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: Theme.of(context)
                  .colorScheme
                  .onBackground
                  .withOpacity(0.75))),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(radius ?? 5),
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5))),
      width: width,
      height: height ?? 40,
    );
  }
}

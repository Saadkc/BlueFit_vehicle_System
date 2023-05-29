import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomDropDownMenu extends StatelessWidget {
  final double width;
  final double? height;
  final List<String> menu;
  final Function(String?) onChanged;
  final String currentSelectedItem;
  final Color? backgroundColor;
  final double? borderRadius;
  final double? bottomMargin;
  final TextStyle? textStyle;
  const CustomDropDownMenu(
      {Key? key,
      required this.width,
      required this.onChanged,
      this.borderRadius,
      this.textStyle,
      this.bottomMargin,
      this.backgroundColor,
      this.height,
      required this.menu,
      required this.currentSelectedItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: (bottomMargin ?? 20)),
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(borderRadius ?? 5),
          border: Border.all(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.5))),
      width: width,
      height: (height ?? 40),
      child: DropdownButton<String>(
          icon: SizedBox(
              height: 15,
              width: 15,
              child: SvgPicture.asset(
                  UiUtils.getImagePath("arrow_down_icon.svg"))),
          underline: SizedBox(),
          isExpanded: true,
          value: currentSelectedItem,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.75)),
          items: menu
              .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    e,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textStyle,
                  )))
              .toList(),
          onChanged: onChanged),
    );
  }
}

import 'package:eschool_teacher/ui/styles/colors.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomSheetTextFieldContainer extends StatelessWidget {
  final String hintText;
  final TextEditingController textEditingController;
  final AlignmentGeometry? contentAlignment;
  final EdgeInsetsGeometry? contentPadding;
  final double? height;
  final int? maxLines;
  final List<TextInputFormatter>? textInputFormatter;
  final TextInputType? keyboardType;

  final EdgeInsetsGeometry? margin;
  final bool? hideText;
  final Widget? suffix;
  final int? maxlength;

  const BottomSheetTextFieldContainer(
      {Key? key,
      required this.hintText,
      required this.maxLines,
      required this.textEditingController,
      this.height,
      this.textInputFormatter,
      this.suffix,
      this.maxlength,
      this.hideText,
      this.keyboardType,
      this.margin,
      this.contentAlignment,
      this.contentPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      alignment: contentAlignment ?? Alignment.center,
      padding: contentPadding ?? EdgeInsetsDirectional.only(start: 20.0),
      child: TextField(
        obscureText: hideText ?? false,
        keyboardType: keyboardType,
        controller: textEditingController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: UiUtils.textFieldFontSize),
        maxLines: maxLines,
        inputFormatters: textInputFormatter,
        decoration: InputDecoration(
          suffixIcon: suffix,
          hintText: hintText,
          hintStyle: TextStyle(
              color: hintTextColor, fontSize: UiUtils.textFieldFontSize),
          border: InputBorder.none,
        ),
        maxLength: maxlength,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: height,
    );
  }
}

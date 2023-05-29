import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchButton extends StatelessWidget {
  final Function onTap;
  final EdgeInsetsDirectional? edgeInsetsDirectional;
  const SearchButton(
      {Key? key, required this.onTap, this.edgeInsetsDirectional})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            decoration:
                BoxDecoration(border: Border.all(color: Colors.transparent)),
            width: 25,
            height: 25,
            child: Icon(
              CupertinoIcons.search, //Icons.calendar_month
              size: 25,
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
        ),
        padding: edgeInsetsDirectional ??
            EdgeInsetsDirectional.only(
              end: UiUtils.screenContentHorizontalPadding,
            ));
  }
}

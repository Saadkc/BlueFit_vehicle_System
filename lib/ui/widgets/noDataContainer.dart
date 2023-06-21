import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoDataContainer extends StatelessWidget {
  final Color? textColor;
  final String titleKey;
  const NoDataContainer({Key? key, this.textColor, required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.35),
            child: SvgPicture.asset(UiUtils.getImagePath("fileNotFound.svg")),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              UiUtils.getTranslatedLabel(context, titleKey),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.secondary,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class BorderedProfilePictureContainer extends StatelessWidget {
  final BoxConstraints boxConstraints;
  final String imageUrl;
  final Function? onTap;
  final double? heightAndWidthPercentage;
  const BorderedProfilePictureContainer(
      {Key? key,
      required this.boxConstraints,
      required this.imageUrl,
      this.heightAndWidthPercentage,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(boxConstraints.maxWidth *
          (heightAndWidthPercentage == null
              ? UiUtils.defaultProfilePictureHeightAndWidthPercentage * (0.5)
              : heightAndWidthPercentage! * (0.5))),
      onTap: () {
        onTap?.call();
      },
      child: Container(
        padding: EdgeInsets.all(4.0),
        child: Container(
            decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: CachedNetworkImageProvider(imageUrl)),
        )),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                width: 1.0, color: Theme.of(context).scaffoldBackgroundColor)),
        width: boxConstraints.maxWidth *
            (heightAndWidthPercentage ??
                UiUtils.defaultProfilePictureHeightAndWidthPercentage),
        height: boxConstraints.maxWidth *
            (heightAndWidthPercentage ??
                UiUtils.defaultProfilePictureHeightAndWidthPercentage),
      ),
    );
  }
}

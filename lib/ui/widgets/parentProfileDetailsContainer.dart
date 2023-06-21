import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool/data/models/parent.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class ParentProfileDetailsContainer extends StatelessWidget {
  final String nameKey; //motherName,fatherName,guardianName and name
  final Parent parent;
  const ParentProfileDetailsContainer(
      {Key? key, required this.nameKey, required this.parent})
      : super(key: key);

  Widget _buildParentDetailsTitleAndValue(
      {required String title,
      required String value,
      required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20.0,
        right: 20.0,
        bottom: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$title",
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
                fontSize: 13.0),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(
            "$value",
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * (0.8),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PositionedDirectional(
              top: -40,
              start: MediaQuery.of(context).size.width * (0.4) - 42.5,
              child: Container(
                width: 85.0,
                height: 85.0,
                padding: EdgeInsets.all(10),
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: CachedNetworkImageProvider(parent.image)),
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 60,
              ),
              Divider(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
                height: 1.25,
              ),
              SizedBox(
                height: 20,
              ),
              _buildParentDetailsTitleAndValue(
                  title: UiUtils.getTranslatedLabel(context, nameKey),
                  context: context,
                  value: UiUtils.formatEmptyValue(
                      "${parent.firstName} ${parent.lastName}")),
              _buildParentDetailsTitleAndValue(
                  context: context,
                  title: UiUtils.getTranslatedLabel(context, dateOfBirthKey),
                  value: UiUtils.formatEmptyValue(parent.dob)),
              _buildParentDetailsTitleAndValue(
                  context: context,
                  title: UiUtils.getTranslatedLabel(context, emailKey),
                  value: UiUtils.formatEmptyValue(parent.email)),
              _buildParentDetailsTitleAndValue(
                  context: context,
                  title: UiUtils.getTranslatedLabel(context, occupationKey),
                  value: UiUtils.formatEmptyValue(parent.occupation)),
              _buildParentDetailsTitleAndValue(
                  context: context,
                  title: UiUtils.getTranslatedLabel(context, phoneNumberKey),
                  value: UiUtils.formatEmptyValue(parent.mobile)),
              _buildParentDetailsTitleAndValue(
                  context: context,
                  title: UiUtils.getTranslatedLabel(context, addressKey),
                  value: UiUtils.formatEmptyValue(parent.currentAddress)),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: Theme.of(context).colorScheme.background),
    );
  }
}

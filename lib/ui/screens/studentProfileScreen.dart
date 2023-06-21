import 'package:cached_network_image/cached_network_image.dart';

import 'package:eschool/data/models/student.dart';
import 'package:eschool/ui/widgets/customAppbar.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentProfileScreen extends StatefulWidget {
  final Student studentDetails;

  StudentProfileScreen({Key? key, required this.studentDetails})
      : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => StudentProfileScreen(
            studentDetails: routeSettings.arguments as Student));
  }
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  Widget _buildProfileDetailsTile(
      {required String label, required String value, required String iconUrl}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(12.5),
            width: 50,
            child: SvgPicture.asset(iconUrl),
            height: 50,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: const Color(0x1a212121),
                      offset: Offset(0, 10),
                      blurRadius: 16,
                      spreadRadius: 0)
                ],
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(15.0)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * (0.05),
          ),
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(top: 3.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w400,
                        fontSize: 12.0),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        title: UiUtils.getTranslatedLabel(context, profileKey),
      ),
    );
  }

  Widget _buildProfileDetailsContainer() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
        ),
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width * (0.25),
                height: MediaQuery.of(context).size.width * (0.25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: CachedNetworkImageProvider(
                            widget.studentDetails.image)),
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary)),
            SizedBox(
              height: 10,
            ),
            Text(
              widget.studentDetails.getFullName(),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "${UiUtils.getTranslatedLabel(context, grNumberKey)} - ${widget.studentDetails.admissionNo}",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 12.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.075)),
              child: Divider(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * (0.075)),
              child: Column(
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      UiUtils.getTranslatedLabel(context, personalDetailsKey),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, classKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.classSectionName),
                      iconUrl: UiUtils.getImagePath("user_pro_class_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, mediumKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.mediumName),
                      iconUrl: UiUtils.getImagePath("medium_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, rollNumberKey),
                      value: widget.studentDetails.rollNumber.toString(),
                      iconUrl:
                          UiUtils.getImagePath("user_pro_roll_no_icon.svg")),
                  _buildProfileDetailsTile(
                      label:
                          UiUtils.getTranslatedLabel(context, dateOfBirthKey),
                      value:
                          UiUtils.formatEmptyValue(widget.studentDetails.dob),
                      iconUrl: UiUtils.getImagePath("user_pro_dob_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(
                          context, currentAddressKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.currentAddress),
                      iconUrl:
                          UiUtils.getImagePath("user_pro_address_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(
                          context, permanentAddressKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.permanentAddress),
                      iconUrl:
                          UiUtils.getImagePath("user_pro_address_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, bloodGroupKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.bloodGroup),
                      iconUrl: UiUtils.getImagePath("blood_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, weightKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.weight),
                      iconUrl: UiUtils.getImagePath("weight_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, heightKey),
                      value: UiUtils.formatEmptyValue(
                          widget.studentDetails.height),
                      iconUrl: UiUtils.getImagePath("height_icon.svg")),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.1),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _buildProfileDetailsContainer(),
        _buildAppBar(),
      ]),
    );
  }
}

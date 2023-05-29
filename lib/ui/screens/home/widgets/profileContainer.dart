import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool_teacher/cubits/authCubit.dart';
import 'package:eschool_teacher/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileContainer extends StatefulWidget {
  ProfileContainer({Key? key}) : super(key: key);

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  /*
  Widget _buildLogoutButton() {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 16,
                width: 16,
                child:
                    SvgPicture.asset(UiUtils.getImagePath("logout_icon.svg"))),
            SizedBox(
              width: 10.0,
            ),
            Text(
              UiUtils.getTranslatedLabel(context, logoutKey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15.0,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ],
        ),
      ),
      width: MediaQuery.of(context).size.width * (0.4),
      height: 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Theme.of(context).colorScheme.secondary),
    );
  }
  */

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

  @override
  Widget build(BuildContext context) {
    final teacher = context.read<AuthCubit>().getTeacherDetails();
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.only(
            bottom: UiUtils.getScrollViewBottomPadding(context)),
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  ScreenTopBackgroundContainer(
                    child: Stack(
                      children: [
                        Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                              UiUtils.getTranslatedLabel(context, profileKey),
                              style: TextStyle(
                                  fontSize: UiUtils.screenTitleFontSize,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ))
                      ],
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    teacher.image,
                                  )),
                              color: Theme.of(context).colorScheme.onBackground,
                              shape: BoxShape.circle),
                        ),
                        width: MediaQuery.of(context).size.width * (0.3),
                        height: MediaQuery.of(context).size.width * (0.3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor),
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height * (0.325),
              width: MediaQuery.of(context).size.width,
            ),
            Text(
              teacher.getFullName(),
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18.0),
            ),
            SizedBox(
              height: 5.0,
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
                    alignment: Alignment.centerLeft,
                    child: Text(
                      UiUtils.getTranslatedLabel(context, personalDetailsKey),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, emailKey),
                      value: teacher.email,
                      iconUrl: UiUtils.getImagePath("user_pro_icon.svg")),
                  _buildProfileDetailsTile(
                      label:
                          UiUtils.getTranslatedLabel(context, phoneNumberKey),
                      value: teacher.mobile,
                      iconUrl: UiUtils.getImagePath("phone-call.svg")),
                  _buildProfileDetailsTile(
                      label:
                          UiUtils.getTranslatedLabel(context, dateOfBirthKey),
                      value: UiUtils.formatStringDate(teacher.dob),
                      iconUrl: UiUtils.getImagePath("user_pro_dob_icon.svg")),

                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(context, genderKey),
                      value: teacher.gender,
                      iconUrl: UiUtils.getImagePath("gender.svg")),

                  _buildProfileDetailsTile(
                      label:
                          UiUtils.getTranslatedLabel(context, qualificationKey),
                      value: teacher.qualification,
                      iconUrl: UiUtils.getImagePath("qualification.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(
                          context, currentAddressKey),
                      value: teacher.currentAddress,
                      iconUrl:
                          UiUtils.getImagePath("user_pro_address_icon.svg")),
                  _buildProfileDetailsTile(
                      label: UiUtils.getTranslatedLabel(
                          context, permantantAddressKey),
                      value: teacher.permanentAddress,
                      iconUrl:
                          UiUtils.getImagePath("user_pro_address_icon.svg")),
                  SizedBox(
                    height: 7.5,
                  ),
                  //_buildLogoutButton(),
                  /*
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                      "${UiUtils.getTranslatedLabel(context, appVersionKey)}  1.0.0",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                          fontWeight: FontWeight.w500,
                          fontSize: 11.0),
                      textAlign: TextAlign.left)
                      */
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

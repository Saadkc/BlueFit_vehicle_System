import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/routes.dart';
import '../../../cubits/authCubit.dart';
import '../../../utils/labelKeys.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/borderedProfilePictureContainer.dart';
import '../../widgets/customShowCaseWidget.dart';
import '../../widgets/screenTopBackgroundContainer.dart';

class NewHomeContainer extends StatefulWidget {
  const NewHomeContainer({Key? key}) : super(key: key);

  @override
  State<NewHomeContainer> createState() => _NewHomeContainerState();
}

class _NewHomeContainerState extends State<NewHomeContainer> {
  GlobalKey _profilePictureNavigationShowCaseGlobalKey = GlobalKey();

  Widget _buildTopProfileContainer(BuildContext context) {
    return ScreenTopBackgroundContainer(
      padding: EdgeInsets.all(0),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Stack(
          children: [
            //Bordered circles
            PositionedDirectional(
              top: MediaQuery.of(context).size.width * (-0.15),
              start: MediaQuery.of(context).size.width * (-0.225),
              child: Container(
                padding: EdgeInsetsDirectional.only(end: 20.0, bottom: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.1)),
                      shape: BoxShape.circle),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.1)),
                    shape: BoxShape.circle),
                width: MediaQuery.of(context).size.width * (0.6),
                height: MediaQuery.of(context).size.width * (0.6),
              ),
            ),

            //bottom fill circle
            PositionedDirectional(
              bottom: MediaQuery.of(context).size.width * (-0.15),
              end: MediaQuery.of(context).size.width * (-0.15),
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .scaffoldBackgroundColor
                        .withOpacity(0.1),
                    shape: BoxShape.circle),
                width: MediaQuery.of(context).size.width * (0.4),
                height: MediaQuery.of(context).size.width * (0.4),
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsetsDirectional.only(
                    start: boxConstraints.maxWidth * (0.075),
                    bottom: boxConstraints.maxHeight * (0.2)),
                child: Row(
                  children: [
                    CustomShowCaseWidget(
                      shapeBorder: CircleBorder(),
                      globalKey: _profilePictureNavigationShowCaseGlobalKey,
                      description: "Tap to view profile",
                      child: BorderedProfilePictureContainer(
                          boxConstraints: boxConstraints,
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                Routes.studentProfile,
                                arguments: context
                                    .read<AuthCubit>()
                                    .getStudentDetails());
                          },
                          imageUrl: context
                              .read<AuthCubit>()
                              .getStudentDetails()
                              .image),
                    ),
                    SizedBox(
                      width: boxConstraints.maxWidth * (0.05),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context
                                    .read<AuthCubit>()
                                    .getStudentDetails()
                                    .getFullName(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "${UiUtils.getTranslatedLabel(context, classKey)}",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                  // SizedBox(
                                  //   width: 10.0,
                                  // ),
                                  // Container(
                                  //   width: 1.5,
                                  //   height: 12.0,
                                  //   color: Theme.of(context)
                                  //       .scaffoldBackgroundColor,
                                  // ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    "${UiUtils.getTranslatedLabel(context, rollNoKey)}",
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.w400,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMiddleWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height *
                UiUtils.appBarBiggerHeightPercentage,
          ),
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.volume_down,
                  size: 80,
                  color: Colors.black,
                ),
                Text(
                  "Promotions",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width / 2 - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.crop_original_rounded,
                      size: 70,
                      color: Colors.black,
                    ),
                    Text(
                      "ORDER",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width / 2 - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      size: 70,
                      color: Colors.black,
                    ),
                    Text(
                      "CHATFIT",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width / 2 - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.receipt,
                      size: 70,
                      color: Colors.black,
                    ),
                    Text(
                      "Report",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width / 2 - 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.settings_outlined,
                      size: 70,
                      color: Colors.black,
                    ),
                    Text(
                      "Settings",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(alignment: Alignment.topCenter, child: _buildMiddleWidget()),
        Align(
          alignment: Alignment.topCenter,
          child: _buildTopProfileContainer(context),
        ),
      ],
    );
  }
}

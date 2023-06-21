import 'package:eschool/app/routes.dart';
import 'package:eschool/cubits/authCubit.dart';
import 'package:eschool/data/models/student.dart';
import 'package:eschool/data/models/subject.dart';
import 'package:eschool/ui/widgets/customBackButton.dart';

import 'package:eschool/ui/widgets/screenTopBackgroundContainer.dart';

import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChildDetailMenuScreen extends StatefulWidget {
  final Student student;
  final List<Subject> subjectsForFilter;
  const ChildDetailMenuScreen(
      {Key? key, required this.student, required this.subjectsForFilter})
      : super(key: key);

  @override
  ChildDetailMenuScreenState createState() => ChildDetailMenuScreenState();

  static Route route(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
      builder: (_) => ChildDetailMenuScreen(
        subjectsForFilter: arguments['subjectsForFilter'],
        student: arguments['student'],
      ),
    );
  }
}

class ChildDetailMenuScreenState extends State<ChildDetailMenuScreen> {
  Widget _buildAppBar(BuildContext context) {
    return ScreenTopBackgroundContainer(
      heightPercentage: UiUtils.appBarSmallerHeightPercentage,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          context.read<AuthCubit>().isParent()
              ? CustomBackButton()
              : SizedBox(),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              UiUtils.getTranslatedLabel(context, menuKey),
              style: TextStyle(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  fontSize: UiUtils.screenTitleFontSize),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInformationAndMenu() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * (0.075),
          right: MediaQuery.of(context).size.width * (0.075),
          top: UiUtils.getScrollViewTopPadding(
              context: context,
              appBarHeightPercentage: UiUtils.appBarMediumtHeightPercentage)),
      child: Column(
        children: [
          _buildMenuContainer(
              route: Routes.childAssignments,
              arguments: {
                "childId": widget.student.id,
                "subjects": widget.subjectsForFilter
              },
              iconPath: UiUtils.getImagePath("assignment_icon_parent.svg"),
              title: UiUtils.getTranslatedLabel(context, assignmentsKey)),
          _buildMenuContainer(
              route: Routes.childTeachers,
              arguments: widget.student.id,
              iconPath: UiUtils.getImagePath("teachers_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, teachersKey)),
          _buildMenuContainer(
              route: Routes.childAttendance,
              arguments: widget.student.id,
              iconPath: UiUtils.getImagePath("attendance_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, attendanceKey)),
          _buildMenuContainer(
              route: Routes.childTimeTable,
              arguments: widget.student.id,
              iconPath: UiUtils.getImagePath("timetable_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, timeTableKey)),
          _buildMenuContainer(
              route: Routes.holidays,
              iconPath: UiUtils.getImagePath("holiday_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, holidaysKey)),
          _buildMenuContainer(
              route: Routes.exam,
              arguments: {
                "childId": widget.student.id,
                "subjects": widget.subjectsForFilter
              },
              iconPath: UiUtils.getImagePath("exam_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, examsKey)),
          _buildMenuContainer(
              route: Routes.childResults,
              arguments: {
                "childId": widget.student.id,
                "subjects": widget.subjectsForFilter
              },
              iconPath: UiUtils.getImagePath("result_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, resultKey)),
          _buildMenuContainer(
              route: Routes.subjectWiseReport,
              arguments: {
                "childId": widget.student.id,
                "subjects": widget.subjectsForFilter
              },
              iconPath: UiUtils.getImagePath("reports_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, reportsKey)),
          _buildMenuContainer(
              route: Routes.childFees,
              arguments: {
                "studentDetails": widget.student,
              },
              iconPath: UiUtils.getImagePath("fees_icon.svg"),
              title: UiUtils.getTranslatedLabel(context, feesKey)),
        ],
      ),
    );
  }

  Widget _buildMenuContainer(
      {required String iconPath,
      required String title,
      Object? arguments,
      required String route}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(route, arguments: arguments);
        },
        child: Container(
          height: 80,
          child: LayoutBuilder(builder: (context, boxConstraints) {
            return Row(
              children: [
                Container(
                  padding: EdgeInsets.all(14),
                  margin: EdgeInsets.symmetric(horizontal: 10.0),
                  height: 60,
                  child: SvgPicture.asset(iconPath),
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onSecondary
                          .withOpacity(0.225),
                      borderRadius: BorderRadius.circular(15.0)),
                  width: boxConstraints.maxWidth * (0.225),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.025),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.475),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
                Spacer(),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  radius: 17.5,
                  child: Icon(
                    Icons.arrow_forward,
                    size: 22.5,
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.035),
                ),
              ],
            );
          }),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                width: 1.0,
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.25),
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildInformationAndMenu(),
          _buildAppBar(context),
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/authCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/internetListenerWidget.dart';
import 'package:eschool_teacher/ui/widgets/screenTopBackgroundContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomeContainer extends StatefulWidget {
  HomeContainer({Key? key}) : super(key: key);

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read<MyClassesCubit>().fetchMyClasses();
    });
    super.initState();
  }

  TextStyle _titleFontStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 17.0,
        fontWeight: FontWeight.w600);
  }

  Widget _buildMyClassesLabel() {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            UiUtils.getTranslatedLabel(context, myClassesKey),
            style: _titleFontStyle(),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

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
                padding: EdgeInsets.only(right: 20.0, bottom: 20.0),
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
                    Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(context
                                  .read<AuthCubit>()
                                  .getTeacherDetails()
                                  .image)),
                          shape: BoxShape.circle,
                          border: Border.all(
                              width: 2.0,
                              color:
                                  Theme.of(context).scaffoldBackgroundColor)),
                      width: boxConstraints.maxWidth * (0.175),
                      height: boxConstraints.maxWidth * (0.175),
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
                                  .getTeacherDetails()
                                  .getFullName(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                            ),
                          ],
                        )
                      ],
                    ))
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildClassShimmerLoading(BoxConstraints boxConstraints) {
    return ShimmerLoadingContainer(
        child: CustomShimmerContainer(
      height: 80,
      borderRadius: 10,
      width: boxConstraints.maxWidth * (0.45),
    ));
  }

  Widget _buildClassContainer(
      {required BoxConstraints boxConstraints,
      required ClassSectionDetails classSectionDetails,
      required int index,
      required bool isClassTeacher}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            Routes.classScreen,
            arguments: {
              "isClassTeacher": isClassTeacher,
              "classSection": classSectionDetails
            },
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  "${classSectionDetails.classDetails.name} - ${classSectionDetails.sectionDetails.name}",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Positioned(
                  bottom: -15,
                  left: (boxConstraints.maxWidth * 0.225) - 15, //0.45
                  child: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                    height: 30,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.2),
                              offset: Offset(0, 4),
                              blurRadius: 20)
                        ],
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ))
            ],
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //Diplaying different(4) class color
              color: UiUtils.getClassColor(index),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: UiUtils.getClassColor(index).withOpacity(0.2),
                    offset: Offset(0, 2.5))
              ]),
          width: boxConstraints.maxWidth * 0.45,
        ),
      ),
    );
  }

  Widget _buildMyClasses() {
    final classes = context.read<MyClassesCubit>().classes();
    return Column(
      children: [
        _buildMyClassesLabel(),
        LayoutBuilder(builder: (context, boxConstraints) {
          return Wrap(
            spacing: boxConstraints.maxWidth * (0.1),
            runSpacing: 40,
            direction: Axis.horizontal,
            children: List.generate(classes.length, (index) => index)
                .map((index) => _buildClassContainer(
                      boxConstraints: boxConstraints,
                      classSectionDetails: classes[index],
                      index: index,
                      isClassTeacher: false,
                    ))
                .toList(),
          );
        }),
      ],
    );
  }

  Widget _buildClassTeacherLabel() {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            UiUtils.getTranslatedLabel(context, classTeacherKey),
            style: _titleFontStyle(),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildClassTeacher() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildClassTeacherLabel(),
        LayoutBuilder(builder: (context, boxConstraints) {
          return _buildClassContainer(
              classSectionDetails:
                  context.read<MyClassesCubit>().primaryClass(),
              boxConstraints: boxConstraints,
              index: 0,
              isClassTeacher: true);
        }),
      ],
    );
  }

  Widget _buildMenuContainer(
      {required String iconPath,
      required String title,
      required String route}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pushNamed(route);
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
                  width: 10.0,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                      fontSize: 15),
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
                  width: 15.0,
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

  Widget _buildInformationAndMenuLabel() {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Text(
            UiUtils.getTranslatedLabel(context, informationKey),
            style: _titleFontStyle(),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _buildInformationShimmerLoadingContainer() {
    return Container(
      margin: EdgeInsets.only(
        bottom: 15,
      ),
      height: 80,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          children: [
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              height: 60,
              width: boxConstraints.maxWidth * (0.225),
            )),
            SizedBox(
              width: boxConstraints.maxWidth * (0.05),
            ),
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              width: boxConstraints.maxWidth * (0.475),
            )),
            Spacer(),
            ShimmerLoadingContainer(
                child: CustomShimmerContainer(
              borderRadius: boxConstraints.maxWidth * (0.035),
              height: boxConstraints.maxWidth * (0.07),
              width: boxConstraints.maxWidth * (0.07),
            )),
          ],
        );
      }),
    );
  }

  Widget _buildInformationAndMenu() {
    return Column(
      children: [
        _buildInformationAndMenuLabel(),
        _buildMenuContainer(
            route: Routes.assignments,
            iconPath: UiUtils.getImagePath("assignment_icon.svg"),
            title: UiUtils.getTranslatedLabel(context, assignmentsKey)),
        _buildMenuContainer(
            route: Routes.announcements,
            iconPath: UiUtils.getImagePath("announcment_icon.svg"),
            title: UiUtils.getTranslatedLabel(context, announcementsKey)),
        _buildMenuContainer(
            route: Routes.lessons,
            iconPath: UiUtils.getImagePath("lesson.svg"),
            title: UiUtils.getTranslatedLabel(context, chaptersKey)),
        _buildMenuContainer(
            route: Routes.topics,
            iconPath: UiUtils.getImagePath("topics.svg"),
            title: UiUtils.getTranslatedLabel(context, topicsKey)),
        _buildMenuContainer(
            route: Routes.holidays,
            iconPath: UiUtils.getImagePath("holiday_icon.svg"),
            title: UiUtils.getTranslatedLabel(context, holidaysKey)),
      _buildMenuContainer(
                route: Routes.exams,
                iconPath: UiUtils.getImagePath("exam_icon.svg"),
                title: UiUtils.getTranslatedLabel(context, examsKey)),
        context.read<MyClassesCubit>().primaryClass().id == '0'
            ? SizedBox()
            : _buildMenuContainer(
                route: Routes.addResultForAllStudents,
                iconPath: UiUtils.getImagePath("result_icon.svg"),
                title: UiUtils.getTranslatedLabel(context, addResultKey),),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return InternetListenerWidget(
      onInternetConnectionBack: () {
        if (context.read<MyClassesCubit>().state is MyClassesFetchFailure) {
          context.read<MyClassesCubit>().fetchMyClasses();
        }
      },
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * (0.075),
                  right: MediaQuery.of(context).size.width * (0.075),
                  bottom: UiUtils.getScrollViewBottomPadding(context),
                  top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarBiggerHeightPercentage)),
              child: BlocBuilder<MyClassesCubit, MyClassesState>(
                builder: (context, state) {
                  if (state is MyClassesFetchSuccess) {
                    return Column(
                      children: [
                        _buildMyClasses(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildClassTeacher(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildInformationAndMenu()
                      ],
                    );
                  }
                  if (state is MyClassesFetchFailure) {
                    return Center(
                      child: ErrorContainer(
                        errorMessageCode: UiUtils.getErrorMessageFromErrorCode(
                            context, state.errorMessage),
                        onTapRetry: () {
                          context.read<MyClassesCubit>().fetchMyClasses();
                        },
                      ),
                    );
                  }

                  return LayoutBuilder(builder: (context, boxConstraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMyClassesLabel(),
                        Wrap(
                          spacing: boxConstraints.maxWidth * (0.1),
                          runSpacing: 40,
                          direction: Axis.horizontal,
                          children: List.generate(
                                  UiUtils.defaultShimmerLoadingContentCount,
                                  (index) => index)
                              .map((index) =>
                                  _buildClassShimmerLoading(boxConstraints))
                              .toList(),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildClassTeacherLabel(),
                        _buildClassShimmerLoading(boxConstraints),
                        SizedBox(
                          height: 20.0,
                        ),
                        _buildInformationAndMenuLabel(),
                        ...List.generate(
                                UiUtils.defaultShimmerLoadingContentCount,
                                (index) => index)
                            .map((e) =>
                                _buildInformationShimmerLoadingContainer())
                            .toList(),
                      ],
                    );
                  });
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildTopProfileContainer(context),
          ),
        ],
      ),
    );
  }
}

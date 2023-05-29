import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/announcementsCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/repositories/announcementRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/widgets/announcementsContainer.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({Key? key}) : super(key: key);

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      SubjectsOfClassSectionCubit(TeacherRepository()),
                ),
                BlocProvider(
                    create: (context) =>
                        AnnouncementsCubit(AnnouncementRepository()))
              ],
              child: AnnouncementsScreen(),
            ));
  }
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  late String currentSelectedClassSection =
      context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  late ScrollController _scrollController = ScrollController()
    ..addListener(_announcementsScrollListener);

  void _announcementsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AnnouncementsCubit>().hasMore()) {
        context.read<AnnouncementsCubit>().fetchMoreAnnouncements(
              subjectId: context
                  .read<SubjectsOfClassSectionCubit>()
                  .getSubjectDetailsByName(currentSelectedSubject)
                  .id,
              classSectionId: context
                  .read<MyClassesCubit>()
                  .getClassSectionDetails(
                      classSectionName: currentSelectedClassSection)
                  .id,
            );
      }
    }
  }

  @override
  void initState() {
    context.read<SubjectsOfClassSectionCubit>().fetchSubjects(context
        .read<MyClassesCubit>()
        .getClassSectionDetails(classSectionName: currentSelectedClassSection)
        .id);
    super.initState();
  }

  void fetchAnnouncements() {
    final subjectId = context
        .read<SubjectsOfClassSectionCubit>()
        .getSubjectDetailsByName(currentSelectedSubject)
        .id;
    if (subjectId != -1) {
      context.read<AnnouncementsCubit>().fetchAnnouncements(
          classSectionId: context
              .read<MyClassesCubit>()
              .getClassSectionDetails(
                  classSectionName: currentSelectedClassSection)
              .id,
          subjectId: subjectId);
    }
  }

  Widget _buildClassAndSubjectDropDowns() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedClassSection = result;
                });

                context
                    .read<AnnouncementsCubit>()
                    .updateState(AnnouncementsInitial());
              }),
          ClassSubjectsDropDownMenu(
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedSubject = result;
                });
                fetchAnnouncements();
              },
              currentSelectedItem: currentSelectedSubject,
              width: boxConstraints.maxWidth),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(onTap: () {
        Navigator.of(context).pushNamed<bool?>(Routes.addOrEditAnnouncement);
      }),
      body: Stack(
        children: [
          CustomRefreshIndicator(
            displacment: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
            onRefreshCallback: () {
              fetchAnnouncements();
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width *
                      UiUtils.screenContentHorizontalPaddingPercentage,
                  right: MediaQuery.of(context).size.width *
                      UiUtils.screenContentHorizontalPaddingPercentage,
                  top: UiUtils.getScrollViewTopPadding(
                      context: context,
                      appBarHeightPercentage:
                          UiUtils.appBarSmallerHeightPercentage)),
              children: [
                _buildClassAndSubjectDropDowns(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * (0.0125),
                ),
                AnnouncementsContainer(
                    classSectionDetails: context
                        .read<MyClassesCubit>()
                        .getClassSectionDetails(
                            classSectionName: currentSelectedClassSection),
                    subject: context
                        .read<SubjectsOfClassSectionCubit>()
                        .getSubjectDetailsByName(currentSelectedSubject)),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
                title: UiUtils.getTranslatedLabel(context, announcementsKey)),
          ),
        ],
      ),
    );
  }
}

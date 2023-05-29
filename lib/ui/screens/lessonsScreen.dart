import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/lessonsCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/repositories/lessonRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/lessonsContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonsScreen extends StatefulWidget {
  const LessonsScreen({Key? key}) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => LessonsCubit(LessonRepository()),
                ),
                BlocProvider(
                  create: (context) =>
                      SubjectsOfClassSectionCubit(TeacherRepository()),
                ),
              ],
              child: LessonsScreen(),
            ));
  }

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  late String currentSelectedClassSection =
      context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  @override
  void initState() {
    context.read<SubjectsOfClassSectionCubit>().fetchSubjects(context
        .read<MyClassesCubit>()
        .getClassSectionDetails(classSectionName: currentSelectedClassSection)
        .id);
    super.initState();
  }

  void fetchLessons() {
    final subjectId = context
        .read<SubjectsOfClassSectionCubit>()
        .getSubjectIdByName(currentSelectedSubject);
    if (subjectId != -1) {
      context.read<LessonsCubit>().fetchLessons(
          classSectionId: context
              .read<MyClassesCubit>()
              .getClassSectionDetails(
                  classSectionName: currentSelectedClassSection)
              .id,
          subjectId: subjectId);
    }
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child:
          CustomAppBar(title: UiUtils.getTranslatedLabel(context, lessonsKey)),
    );
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
                context.read<LessonsCubit>().updateState(LessonsInitial());
              }),

          //
          ClassSubjectsDropDownMenu(
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedSubject = result;
                });
                fetchLessons();
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
          Navigator.of(context).pushNamed(Routes.addOrEditLesson);
        }),
        body: Stack(
          children: [
            CustomRefreshIndicator(
              displacment: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage),
              onRefreshCallback: () {
                fetchLessons();
              },
              child: ListView(
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
                  LessonsContainer(
                    classSectionDetails: context
                        .read<MyClassesCubit>()
                        .getClassSectionDetails(
                            classSectionName: currentSelectedClassSection),
                    subject: context
                        .read<SubjectsOfClassSectionCubit>()
                        .getSubjectDetailsByName(currentSelectedSubject),
                  )
                ],
              ),
            ),
            _buildAppbar()
          ],
        ));
  }
}

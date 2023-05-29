import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/lessonsCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/cubits/topicsCubit.dart';
import 'package:eschool_teacher/data/repositories/lessonRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/data/repositories/topicRepository.dart';
import 'package:eschool_teacher/ui/widgets/classSubjectsDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customFloatingActionButton.dart';
import 'package:eschool_teacher/ui/widgets/customRefreshIndicator.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/myClassesDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/topicsContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicsScreen extends StatefulWidget {
  TopicsScreen({
    Key? key,
  }) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => LessonsCubit(LessonRepository()),
              ),
              BlocProvider(
                create: (context) =>
                    SubjectsOfClassSectionCubit(TeacherRepository()),
              ),
              BlocProvider(
                create: (context) => TopicsCubit(TopicRepository()),
              ),
            ], child: TopicsScreen()));
  }

  @override
  State<TopicsScreen> createState() => _TopicsScreenState();
}

class _TopicsScreenState extends State<TopicsScreen> {
  late String currentSelectedClassSection =
      context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  late String currentSelectedLesson =
      UiUtils.getTranslatedLabel(context, fetchingLessonsKey);

  @override
  void initState() {
    context.read<SubjectsOfClassSectionCubit>().fetchSubjects(context
        .read<MyClassesCubit>()
        .getClassSectionDetails(classSectionName: currentSelectedClassSection)
        .id);
    super.initState();
  }

  Widget _buildClassSubjectAndLessonDropDowns() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (value) {
                currentSelectedClassSection = value;
                context.read<LessonsCubit>().updateState(LessonsInitial());
                context.read<TopicsCubit>().updateState(TopicsInitial());
                setState(() {});
              }),
          ClassSubjectsDropDownMenu(
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedSubject = result;
                });
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

                  context.read<TopicsCubit>().updateState(TopicsInitial());
                }
              },
              currentSelectedItem: currentSelectedSubject,
              width: boxConstraints.maxWidth),
          //

          BlocConsumer<LessonsCubit, LessonsState>(builder: (context, state) {
            return state is LessonsFetchSuccess
                ? state.lessons.isEmpty
                    ? DefaultDropDownLabelContainer(
                        titleLabelKey:
                            UiUtils.getTranslatedLabel(context, noLessonsKey),
                        width: boxConstraints.maxWidth)
                    : CustomDropDownMenu(
                        width: boxConstraints.maxWidth,
                        onChanged: (value) {
                          currentSelectedLesson = value!;
                          setState(() {});
                          context.read<TopicsCubit>().fetchTopics(
                              lessonId: context
                                  .read<LessonsCubit>()
                                  .getLessonByName(currentSelectedLesson)
                                  .id);
                        },
                        menu: state.lessons.map((e) => e.name).toList(),
                        currentSelectedItem: currentSelectedLesson)
                : DefaultDropDownLabelContainer(
                    titleLabelKey: fetchingLessonsKey,
                    width: boxConstraints.maxWidth);
          }, listener: (context, state) {
            if (state is LessonsFetchSuccess) {
              if (state.lessons.isNotEmpty) {
                setState(() {
                  currentSelectedLesson = state.lessons.first.name;
                });
                context.read<TopicsCubit>().fetchTopics(
                    lessonId: context
                        .read<LessonsCubit>()
                        .getLessonByName(currentSelectedLesson)
                        .id);
              }
            }
          }),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionAddButton(onTap: () {
        Navigator.of(context).pushNamed(Routes.addOrEditTopic);
      }),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: CustomRefreshIndicator(
              onRefreshCallback: () {
                context.read<TopicsCubit>().fetchTopics(
                    lessonId: context
                        .read<LessonsCubit>()
                        .getLessonByName(currentSelectedLesson)
                        .id);
              },
              displacment: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage),
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
                  //
                  _buildClassSubjectAndLessonDropDowns(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.0125),
                  ),

                  BlocBuilder<LessonsCubit, LessonsState>(
                    builder: (context, state) {
                      if (state is LessonsFetchSuccess &&
                          state.lessons.isEmpty) {
                        return SizedBox();
                      }
                      return TopicsContainer(
                          classSectionDetails: context
                              .read<MyClassesCubit>()
                              .getClassSectionDetails(
                                  classSectionName:
                                      currentSelectedClassSection),
                          subject: context
                              .read<SubjectsOfClassSectionCubit>()
                              .getSubjectDetailsByName(currentSelectedSubject),
                          lesson: context.read<LessonsCubit>().getLessonByName(
                                currentSelectedLesson,
                              ));
                    },
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, topicsKey),
            ),
          ),
        ],
      ),
    );
  }
}

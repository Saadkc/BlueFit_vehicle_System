import 'package:eschool_teacher/app/routes.dart';
import 'package:eschool_teacher/cubits/assignmentCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/subjectsOfClassSectionCubit.dart';
import 'package:eschool_teacher/data/repositories/assignmentRepository.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:eschool_teacher/ui/screens/assignments/widgets/assignmentsContainer.dart';
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

class AssignmentsScreen extends StatefulWidget {
  AssignmentsScreen({Key? key}) : super(key: key);

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
              BlocProvider<SubjectsOfClassSectionCubit>(
                create: (context) => SubjectsOfClassSectionCubit(
                  TeacherRepository(),
                ),
              ),
              BlocProvider<AssignmentCubit>(
                  create: (context) => AssignmentCubit(
                        AssignmentRepository(),
                      )),
            ], child: AssignmentsScreen()));
  }

  @override
  State<AssignmentsScreen> createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late ScrollController _scrollController = ScrollController()
    ..addListener(_announcementsScrollListener);

  void _announcementsScrollListener() {
    if (_scrollController.offset ==
        _scrollController.position.maxScrollExtent) {
      if (context.read<AssignmentCubit>().hasMore()) {
        context.read<AssignmentCubit>().fetchMoreAssignment(
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

  void fetchAssignment() {
    final subjectId = context
        .read<SubjectsOfClassSectionCubit>()
        .getSubjectDetailsByName(currentSelectedSubject)
        .id;
    if (subjectId != -1) {
      context.read<AssignmentCubit>().fetchassignment(
          classSectionId: context
              .read<MyClassesCubit>()
              .getClassSectionDetails(
                  classSectionName: currentSelectedClassSection)
              .id,
          subjectId: subjectId);
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

  late String currentSelectedClassSection =
      context.read<MyClassesCubit>().getClassSectionName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
          title: UiUtils.getTranslatedLabel(context, assignmentsKey)),
    );
  }

  Widget _buildAssignmentFilters() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          MyClassesDropDownMenu(
              currentSelectedItem: currentSelectedClassSection,
              width: boxConstraints.maxWidth,
              changeSelectedItem: (result) {
                setState(
                  () {
                    currentSelectedClassSection = result;
                  },
                );

                context
                    .read<AssignmentCubit>()
                    .updateState(AssignmentInitial());
              }),

          //
          ClassSubjectsDropDownMenu(
              changeSelectedItem: (result) {
                setState(() {
                  currentSelectedSubject = result;
                });
                fetchAssignment();
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
        Navigator.of(context).pushNamed(Routes.addAssignment,
            arguments: {"editAssignment": false});
      }),
      body: Stack(
        children: [
          CustomRefreshIndicator(
            displacment: UiUtils.getScrollViewTopPadding(
                context: context,
                appBarHeightPercentage: UiUtils.appBarSmallerHeightPercentage),
            onRefreshCallback: () {
              fetchAssignment();
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
                _buildAssignmentFilters(),
                SizedBox(
                  height: 10,
                ),
                AssignmentsContainer(
                  classSectionDetails: context
                      .read<MyClassesCubit>()
                      .getClassSectionDetails(
                          classSectionName: currentSelectedClassSection),
                  subject: context
                      .read<SubjectsOfClassSectionCubit>()
                      .getSubjectDetailsByName(currentSelectedSubject),
                ),
              ],
            ),
          ),
          _buildAppbar()
        ],
      ),
    );
  }
}

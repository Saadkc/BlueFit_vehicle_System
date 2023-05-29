import 'package:eschool_teacher/cubits/examCubit.dart';
import 'package:eschool_teacher/cubits/examTimeTableCubit.dart';
import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/studentsByClassSectionCubit.dart';
import 'package:eschool_teacher/cubits/submitSubjectMarksBySubjectIdCubit.dart';
import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/ui/screens/result/widget/addMarksContainer.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customDropDownMenu.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/ui/widgets/customShimmerContainer.dart';
import 'package:eschool_teacher/ui/widgets/defaultDropDownLabelContainer.dart';
import 'package:eschool_teacher/ui/widgets/errorContainer.dart';
import 'package:eschool_teacher/ui/widgets/noDataContainer.dart';
import 'package:eschool_teacher/ui/widgets/shimmerLoadingContainer.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddResultForAllStudents extends StatefulWidget {
  const AddResultForAllStudents({
    Key? key,
  }) : super(key: key);

  @override
  State<AddResultForAllStudents> createState() =>
      _AddResultForAllStudentsState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
              BlocProvider<ExamDetailsCubit>(
                create: (context) => ExamDetailsCubit(StudentRepository()),
              ),
              BlocProvider<ExamTimeTableCubit>(
                create: (context) => ExamTimeTableCubit(StudentRepository()),
              ),
              BlocProvider(
                create: (context) =>
                    StudentsByClassSectionCubit(StudentRepository()),
              ),
              BlocProvider(
                create: (context) => SubjectMarksBySubjectIdCubit(
                    studentRepository: StudentRepository()),
              ),
            ], child: AddResultForAllStudents()));
  }
}

class _AddResultForAllStudentsState extends State<AddResultForAllStudents> {
  late String currentSelectedExamName =
      context.read<ExamDetailsCubit>().getExamName().first;

  late String currentSelectedSubject =
      UiUtils.getTranslatedLabel(context, fetchingSubjectsKey);

  late String totalMarksOfSelectedSubject = '';

  Subject? selectedSubjectDetails;

  late List<TextEditingController> obtainedMarksTextEditingController = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      fetchExamList();
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    for (int i = 0; i < obtainedMarksTextEditingController.length; i++) {
      obtainedMarksTextEditingController[i].dispose();
    }
  }

  void fetchExamList() {
    //
    context
        .read<ExamDetailsCubit>()
        .fetchStudentExamsList(examStatus: 3, publishStatus: 0);
  }

  //
  void fetchStudentList() {
    context.read<StudentsByClassSectionCubit>().fetchStudents(
        classSectionId: context.read<MyClassesCubit>().primaryClass().id);
  }

  //
  void fetchStudentExamTimeTableOfExam({required String examName}) {
    context.read<ExamTimeTableCubit>().fetchStudentExamTimeTable(
        examID: context
            .read<ExamDetailsCubit>()
            .getExamDetailsByExamName(examName: examName)
            .examID!);
  }

  //
  Widget _buildExamListDropdown({required double width}) {
    return BlocConsumer<ExamDetailsCubit, ExamDetailsState>(
        builder: (context, state) {
      return state is ExamDetailsFetchSuccess
          ? state.examList.isEmpty
              ? DefaultDropDownLabelContainer(
                  titleLabelKey:
                      UiUtils.getTranslatedLabel(context, noExamsKey),
                  width: width)
              : CustomDropDownMenu(
                  width: width,
                  onChanged: (result) {
                    //
                    //clear all the created textController list
                    obtainedMarksTextEditingController = [];
                    setState(() {
                      currentSelectedExamName = result!;

                      // we will change currentSelectedSubject value to fetchingSubjectsKey label,
                      // because we are using this value to validate subject currentSelectedItem value
                      currentSelectedSubject = UiUtils.getTranslatedLabel(
                          context, fetchingSubjectsKey);
                    });

                    //
                    context
                        .read<StudentsByClassSectionCubit>()
                        .updateState(StudentsByClassSectionFetchInProgress());

                    //
                    fetchStudentExamTimeTableOfExam(examName: result!);
                  },
                  menu: context.read<ExamDetailsCubit>().getExamName(),
                  currentSelectedItem: currentSelectedExamName)
          : DefaultDropDownLabelContainer(
              titleLabelKey: fetchingExamsKey, width: width);
    }, listener: (context, state) {
      if (state is ExamDetailsFetchSuccess) {
        if (state.examList.isNotEmpty) {
          setState(() {
            currentSelectedExamName =
                context.read<ExamDetailsCubit>().getExamName().first;
          });

          fetchStudentExamTimeTableOfExam(examName: currentSelectedExamName);
        } else {
          context
              .read<ExamTimeTableCubit>()
              .updateState(ExamTimeTableFetchSuccess(examTimeTableList: []));
          context
              .read<StudentsByClassSectionCubit>()
              .updateState(StudentsByClassSectionFetchSuccess(students: []));
        }
      }
    });
  }

  //
  Widget _buildSubjectListDropdown({required double width}) {
    return BlocConsumer<ExamTimeTableCubit, ExamTimeTableState>(
        builder: (context, state) {
      return state is ExamTimeTableFetchSuccess
          ? state.examTimeTableList.isEmpty
              ? DefaultDropDownLabelContainer(
                  titleLabelKey:
                      UiUtils.getTranslatedLabel(context, noSubjectsKey),
                  width: width)
              : CustomDropDownMenu(
                  width: width,
                  onChanged: (result) {
                    //clear all the created textController list
                    obtainedMarksTextEditingController = [];

                    //fetch selected subject details
                    selectedSubjectDetails = context
                        .read<ExamTimeTableCubit>()
                        .getSubjectDetailsBySubjectName(subjectName: result!);
                    //
                    setState(() {
                      currentSelectedSubject = result;
                    });
                  },
                  menu: context.read<ExamTimeTableCubit>().getSubjectName(),
                  currentSelectedItem: currentSelectedSubject ==
                          UiUtils.getTranslatedLabel(
                              context, fetchingSubjectsKey)
                      ? context
                          .read<ExamTimeTableCubit>()
                          .getSubjectName()
                          .first
                      : currentSelectedSubject)
          : DefaultDropDownLabelContainer(
              titleLabelKey: fetchingSubjectsKey, width: width);
    }, listener: (context, state) {
      if (state is ExamTimeTableFetchSuccess) {
        if (state.examTimeTableList.isNotEmpty) {
          selectedSubjectDetails = context
              .read<ExamTimeTableCubit>()
              .getSubjectDetailsBySubjectName(
                  subjectName: context
                      .read<ExamTimeTableCubit>()
                      .getSubjectName()
                      .first);
          fetchStudentList();
        }
      } else if (state is ExamTimeTableFetchFailure) {
        UiUtils.showBottomToastOverlay(
            context: context,
            backgroundColor: Theme.of(context).colorScheme.error,
            errorMessage: state.errorMessage);
      }
    });
  }

  Widget _buildResultFilters() {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Column(
        children: [
          //Exam List
          _buildExamListDropdown(width: boxConstraints.maxWidth),

          //Subject List
          _buildSubjectListDropdown(width: boxConstraints.maxWidth),
        ],
      );
    });
  }

  TextStyle _getResultTitleTextStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w600,
        fontSize: 12.0);
  }

  Widget _buildResultTitleDetails() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      height: 50,
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: boxConstraints.maxWidth * (0.1),
              child: Text(
                UiUtils.getTranslatedLabel(context, rollNoKey),
                style: _getResultTitleTextStyle(),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: boxConstraints.maxWidth * (0.4),
              child: Text(
                UiUtils.getTranslatedLabel(context, studentsKey),
                style: _getResultTitleTextStyle(),
              ),
            ),
            Container(
              alignment: Alignment.center,
              width: boxConstraints.maxWidth * (0.2),
              child: Text(
                UiUtils.getTranslatedLabel(context, obtainedKey),
                style: _getResultTitleTextStyle(),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              width: boxConstraints.maxWidth * (0.2),
              child: Text(
                UiUtils.getTranslatedLabel(context, totalKey),
                style: _getResultTitleTextStyle(),
              ),
            ),
          ],
        );
      }),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.075),
                offset: Offset(2.5, 2.5),
                blurRadius: 5,
                spreadRadius: 1)
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      width: MediaQuery.of(context).size.width,
    );
  }

  Widget _buildSubmitButton(
      {required String totalMarks, required List<Student> studentList}) {
    return BlocConsumer<SubjectMarksBySubjectIdCubit,
        SubjectMarksBySubjectIdState>(
      listener: (context, state) {
        if (state is SubjectMarksBySubjectIdSubmitSuccess) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getTranslatedLabel(
                  context, marksAddedSuccessfullyKey),
              backgroundColor: Theme.of(context).colorScheme.onPrimary);

          obtainedMarksTextEditingController.forEach((element) {
            element.clear();
          });
          //Navigator.of(context).pop();
        } else if (state is SubjectMarksBySubjectIdSubmitFailure) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getErrorMessageFromErrorCode(
                  context, state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
        }
      },
      builder: (context, state) {
        return CustomRoundedButton(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            bool hasError = false;
            List<Map<String, dynamic>> studentsMarksList = [];
            for (int index = 0;
                index < obtainedMarksTextEditingController.length;
                index++) {
              //

              String inputMarks =
                  obtainedMarksTextEditingController[index].text;

              //
              if (inputMarks != '') {
                if (double.parse(inputMarks) > double.parse(totalMarks)) {
                  UiUtils.showBottomToastOverlay(
                      context: context,
                      errorMessage: UiUtils.getTranslatedLabel(
                          context, marksMoreThanTotalMarksKey),
                      backgroundColor: Theme.of(context).colorScheme.error);

                  hasError = true;
                  break;
                }

                studentsMarksList.add({
                  'obtained_marks': inputMarks,
                  'student_id': studentList[index].id
                });
              }
            }

            if (studentsMarksList.length !=
                    obtainedMarksTextEditingController.length &&
                !hasError) {
              //if marks of all students are not inserted then error message will be shown

              UiUtils.showBottomToastOverlay(
                  context: context,
                  errorMessage: UiUtils.getTranslatedLabel(
                      context, pleaseEnterAllMarksKey),
                  backgroundColor: Theme.of(context).colorScheme.error);
              return;
            }
            //if marks list is empty and doesn't show any error message before then this will be shown
            if (studentsMarksList.isEmpty && !hasError) {
              UiUtils.showBottomToastOverlay(
                  context: context,
                  backgroundColor: Theme.of(context).colorScheme.error,
                  errorMessage: UiUtils.getTranslatedLabel(
                      context, pleaseEnterSomeDataKey));

              return;
            }

            if (hasError) return;

            context
                .read<SubjectMarksBySubjectIdCubit>()
                .submitSubjectMarksBySubjectId(
                    examId: context
                        .read<ExamDetailsCubit>()
                        .getExamDetailsByExamName(
                            examName: currentSelectedExamName)
                        .examID!,
                    subjectId: selectedSubjectDetails!.id,
                    bodyParameter: studentsMarksList);
          },
          height: UiUtils.bottomSheetButtonHeight,
          widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          buttonTitle: UiUtils.getTranslatedLabel(context, submitResultKey),
          showBorder: false,
          child: state is SubjectMarksBySubjectIdSubmitInProgress
              ? CustomCircularProgressIndicator(
                  strokeWidth: 2,
                  widthAndHeight: 20,
                )
              : null,
        );
      },
    );
  }

  Widget _buildStudentContainer() {
    return BlocConsumer<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      listener: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          //create textController
          for (var i = 0; i < state.students.length; i++) {
            obtainedMarksTextEditingController.add(TextEditingController());
          }
          //
          totalMarksOfSelectedSubject = context
              .read<ExamTimeTableCubit>()
              .getTotalMarksOfSubject(subjectId: selectedSubjectDetails!.id);
        }
      },
      builder: (context, state) {
        //
        if (state is StudentsByClassSectionFetchSuccess) {
          //
          if (state.students.isEmpty) {
            return NoDataContainer(
                titleKey: UiUtils.getTranslatedLabel(context, noDataFoundKey));
          }
          //
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildResultTitleDetails(),
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.04),
              ),
              Column(
                  children: List.generate(state.students.length, (index) {
                //
                return AddMarksContainer(
                  alias: state.students[index].rollNumber.toString(),
                  obtainedMarksTextEditingController:
                      obtainedMarksTextEditingController[index],
                  title:
                      '${state.students[index].firstName} ${state.students[index].lastName}',
                  totalMarks: totalMarksOfSelectedSubject,
                );
                //
              })),
              //
              SizedBox(
                height: MediaQuery.of(context).size.height * (0.09),
              ),
            ],
          );
        }
        if (state is StudentsByClassSectionFetchFailure) {
          return ErrorContainer(
            errorMessageCode: state.errorMessage,
            onTapRetry: () => fetchStudentList(),
          );
        }
        return _buildStudentListShimmerContainer();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            //  controller: _scrollController,
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width *
                  UiUtils.screenContentHorizontalPaddingPercentage,
              right: MediaQuery.of(context).size.width *
                  UiUtils.screenContentHorizontalPaddingPercentage,
              top: UiUtils.getScrollViewTopPadding(
                  context: context,
                  appBarHeightPercentage:
                      UiUtils.appBarSmallerHeightPercentage),
            ),
            children: [
              _buildResultFilters(),
              SizedBox(
                height: 10,
              ),
              _buildStudentContainer()
            ],
          ),
          _buildSubmitButtonContainer(),
          Align(
            alignment: Alignment.topCenter,
            child: CustomAppBar(
              title: UiUtils.getTranslatedLabel(context, addResultKey),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSubmitButtonContainer() {
    return BlocBuilder<StudentsByClassSectionCubit,
        StudentsByClassSectionState>(
      builder: (context, state) {
        if (state is StudentsByClassSectionFetchSuccess) {
          return state.students.isEmpty
              ? SizedBox()
              : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.02,
                    ),
                    child: _buildSubmitButton(
                        totalMarks: context
                            .read<ExamTimeTableCubit>()
                            .getTotalMarksOfSubject(
                                subjectId: selectedSubjectDetails!.id),
                        studentList: (context
                                .read<StudentsByClassSectionCubit>()
                                .state as StudentsByClassSectionFetchSuccess)
                            .students),
                  ));
        }
        return SizedBox();
      },
    );
  }

  Widget _buildStudentListShimmerContainer() {
    return Column(
      children:
          List.generate(UiUtils.defaultShimmerLoadingContentCount, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Container(
            child: LayoutBuilder(builder: (context, boxConstraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                    margin: EdgeInsetsDirectional.only(
                        end: boxConstraints.maxWidth * (0.3)),
                  )),
                  SizedBox(
                    height: 5,
                  ),
                ],
              );
            }),
            padding: EdgeInsets.symmetric(vertical: 15.0),
            width: MediaQuery.of(context).size.width * (0.85),
          ),
        );
      }),
    );
  }
}

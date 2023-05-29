import 'package:eschool_teacher/cubits/myClassesCubit.dart';
import 'package:eschool_teacher/cubits/submitSubjectMarksByStudentIdCubit.dart';
import 'package:eschool_teacher/data/models/studentResult.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:eschool_teacher/ui/screens/result/widget/addMarksContainer.dart';
import 'package:eschool_teacher/ui/widgets/customAppbar.dart';
import 'package:eschool_teacher/ui/widgets/customCircularProgressIndicator.dart';
import 'package:eschool_teacher/ui/widgets/customRoundedButton.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddResultScreen extends StatefulWidget {
  final StudentResult studentResultData;
  final String studentName;
  final int studentId;

  const AddResultScreen(
      {Key? key,
      required this.studentResultData,
      required this.studentName,
      required this.studentId})
      : super(key: key);

  static Route route(RouteSettings routeSettings) {
    final studentData = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(
        builder: (_) => BlocProvider(
              create: (context) => SubjectMarksByStudentIdCubit(
                  studentRepository: StudentRepository()),
              child: AddResultScreen(
                studentResultData: studentData['studentResultData'],
                studentName: studentData['studentName'],
                studentId: studentData['studentId'],
              ),
            ));
  }

  @override
  State<AddResultScreen> createState() => _AddResultScreenState();
}

class _AddResultScreenState extends State<AddResultScreen> {
  late List<TextEditingController> obtainedMarksTextEditingController = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.studentResultData.marksData!.length; i++) {
      var marksData = widget.studentResultData.marksData![i];
      //
      // If marks is already assign then we will show it over there
      String obtainedMarks = '';
      if (marksData.marks != {}) {
        obtainedMarks = marksData.marks!.obtainedMarks == -1
            ? ''
            : marksData.marks!.obtainedMarks.toString();
      }

      obtainedMarksTextEditingController
          .add(TextEditingController(text: obtainedMarks));
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < widget.studentResultData.marksData!.length; i++) {
      obtainedMarksTextEditingController[i].dispose();
    }
    super.dispose();
  }

  TextStyle _getResultTitleTextStyle() {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontWeight: FontWeight.w600,
        fontSize: 12.0);
  }

  Widget _buildAppbar() {
    return Align(
      alignment: Alignment.topCenter,
      child: CustomAppBar(
        title: widget.studentResultData.examName!,
        subTitle: UiUtils.getTranslatedLabel(context, addResultKey),
      ),
    );
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
                UiUtils.getTranslatedLabel(context, subjectCodeKey),
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: _getResultTitleTextStyle(),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: boxConstraints.maxWidth * (0.4),
              child: Text(
                UiUtils.getTranslatedLabel(context, subjectsKey),
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

  Widget _buildSubjectListContainer() {
    final List<Widget> children = [];
    for (var i = 0; i < widget.studentResultData.marksData!.length; i++) {
      var data = widget.studentResultData.marksData![i];
      children.add(AddMarksContainer(
          alias: data.subjectCode!,
          title: data.subjectName!,
          obtainedMarksTextEditingController:
              obtainedMarksTextEditingController[i],
          totalMarks: data.totalMarks!,
          isReadOnly:
              widget.studentResultData.result!.resultId == 0 ? false : true));
    }
    return Column(
      children: children,
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<SubjectMarksByStudentIdCubit,
        SubjectMarksByStudentIdState>(
      listener: (context, state) {
        if (state is SubjectMarksByStudentIdSubmitSuccess) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getTranslatedLabel(
                  context, marksAddedSuccessfullyKey),
              backgroundColor: Theme.of(context).colorScheme.onPrimary);

          Navigator.of(context).pop("true");
        } else if (state is SubjectMarksByStudentIdSubmitFailure) {
          UiUtils.showBottomToastOverlay(
              context: context,
              errorMessage: UiUtils.getErrorMessageFromErrorCode(
                  context, state.errorMessage),
              backgroundColor: Theme.of(context).colorScheme.error);
        }
      },
      builder: (context, state) {
        return CustomRoundedButton(
          height: UiUtils.bottomSheetButtonHeight,
          widthPercentage: UiUtils.bottomSheetButtonWidthPercentage,
          backgroundColor: Theme.of(context).colorScheme.primary,
          buttonTitle: UiUtils.getTranslatedLabel(context, submitResultKey),
          showBorder: false,
          child: state is SubjectMarksByStudentIdSubmitInProgress
              ? CustomCircularProgressIndicator(
                  strokeWidth: 2,
                  widthAndHeight: 20,
                )
              : null,
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
            bool hasError = false;
            List<Map<String, dynamic>> studentsMarksList = [];
            for (int index = 0;
                index < widget.studentResultData.marksData!.length;
                index++) {
              //
              String inputMarks =
                  obtainedMarksTextEditingController[index].text;
              //
              if (inputMarks != '') {
                if (double.parse(inputMarks) >
                    double.parse(widget
                        .studentResultData.marksData![index].totalMarks!)) {
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
                  'subject_id':
                      widget.studentResultData.marksData![index].subjectId
                });
              }
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
                .read<SubjectMarksByStudentIdCubit>()
                .submitSubjectMarksByStudentId(
                    examId: widget.studentResultData.examId!,
                    studentId: widget.studentId,
                    bodyParameter: studentsMarksList);
          },
        );
      },
    );
  }

  Widget _buildObtainedMarksContainer(BuildContext context) {
    ResultData studentResultData = widget.studentResultData.result!;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Text(
          "${UiUtils.getTranslatedLabel(context, obtainedMarksKey)}  :  ${studentResultData.obtainedMarks}/${studentResultData.totalMarks}",
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary, fontSize: 15)),
      height: 60,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).colorScheme.secondary.withOpacity(0.075),
                offset: Offset(2.5, 2.5),
                blurRadius: 5,
                spreadRadius: 0)
          ],
          color: Theme.of(context).scaffoldBackgroundColor),
      width: MediaQuery.of(context).size.width * (0.85),
    );
  }

  Widget _buildPercentageAndGradeTitleAndValueContainer(
      {required BuildContext context,
      required String title,
      required String value}) {
    return Column(
      children: [
        Text(title,
            style: TextStyle(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.75),
                fontWeight: FontWeight.w400,
                fontSize: 13.0),
            textAlign: TextAlign.left),
        SizedBox(
          height: 5.0,
        ),
        Text(
          value,
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 15.0),
        )
      ],
    );
  }

  Widget _buildPercentageAndGradeContainer(BuildContext context) {
    ResultData studentResultData = widget.studentResultData.result!;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPercentageAndGradeTitleAndValueContainer(
              context: context,
              title: UiUtils.getTranslatedLabel(context, gradeKey),
              value: studentResultData.grade!),
          _buildPercentageAndGradeTitleAndValueContainer(
              context: context,
              title: UiUtils.getTranslatedLabel(context, percentageKey),
              value: studentResultData.percentage!.toString()),
        ],
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.background),
      width: MediaQuery.of(context).size.width * (0.85),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: UiUtils.getScrollViewTopPadding(
                    context: context,
                    appBarHeightPercentage:
                        UiUtils.appBarSmallerHeightPercentage),
                left: MediaQuery.of(context).size.width * (0.075),
                right: MediaQuery.of(context).size.width * (0.075),
              ),
              child: Column(
                children: [
                  //
                  _buildResultTitleDetails(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.04),
                  ),

                  _buildSubjectListContainer(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * (0.1),
                  ),
                  if (widget.studentResultData.result!.resultId != 0)
                    Column(
                      children: [
                        _buildObtainedMarksContainer(context),
                        SizedBox(
                          height: 35,
                        ),
                        _buildPercentageAndGradeContainer(context),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    )
                ],
              ),
            ),
            alignment: Alignment.topCenter,
          ),
          //
          //If result is not declared and teacher is class teacher
          // then show submit marks option
          if (widget.studentResultData.result!.resultId == 0 &&
              context.read<MyClassesCubit>().primaryClass().id != '0')
            Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: _buildSubmitButton(),
                )),
          _buildAppbar(),
        ],
      ),
    );
  }
}

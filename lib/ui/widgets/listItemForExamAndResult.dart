import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class ListItemForExamAndResult extends StatelessWidget {
  final String examStartingDate;
  final String examName;
  final String resultGrade;
  final double resultPercentage;
  final VoidCallback onItemTap;

  ListItemForExamAndResult(
      {Key? key,
        required this.examStartingDate,
        required this.examName,
        required this.resultGrade,
        required this.resultPercentage,
        required this.onItemTap})
      : super(key: key);

  Widget _buildDetailsBackgroundContainer(
      {required Widget child, required BuildContext context}) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        width: MediaQuery.of(context).size.width * (0.85),
        child: child,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }

  TextStyle _getExamDetailsLabelTextStyle({required BuildContext context}) {
    return TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
        fontSize: 12,
        fontWeight: FontWeight.w400);
  }

  Widget _buildExamNameLabelAndDateContainer(
      {required BuildContext context, String? examDate}) {
    return Row(
      children: [
        Text(
          UiUtils.getTranslatedLabel(context, examNameKey),
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
        Spacer(),
        Text(
          '${UiUtils.getTranslatedLabel(context, dateKey)}: ',
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
        Text(
          examDate == '' ? '--' : UiUtils.formatDate(DateTime.parse(examDate!)),
          style: _getExamDetailsLabelTextStyle(context: context),
        ),
      ],
    );
  }

  TextStyle _getExamNameValueTextStyle(
      {required BuildContext context}) {
    return TextStyle(
        color: Theme.of(context).colorScheme.secondary,
        fontSize: 14,
        fontWeight: FontWeight.w600);
  }

  Widget _buildExamNameContainer(
      {required String examName, required BuildContext context}) {
    return Text(
      examName,
      style: _getExamNameValueTextStyle(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemTap,
      child: _buildDetailsBackgroundContainer(
          context: context,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildExamNameLabelAndDateContainer(
                  context: context, examDate: examStartingDate),
              SizedBox(
                height: 5.0,
              ),
              _buildExamNameContainer(examName: examName, context: context),
              resultGrade != '' && resultPercentage != 0
                  ? _buildResultGradeAndPercentageContainer(context: context)
                  : Container()
            ],
          )),
    );
  }

  Widget _buildResultGradeAndPercentageContainer(
      {required BuildContext context}) {
    return Column(
      children: [
        Divider(),
        Row(
          children: [
            Row(
              children: [
                Text("${UiUtils.getTranslatedLabel(context, gradeKey)} - ",
                  style: _getExamNameValueTextStyle(context: context),),
                Text('${resultGrade}'),
              ],
            ),
            Spacer(),
            Row(
              children: [
                Text( "${UiUtils.getTranslatedLabel(context, percentageKey)} : ",
                  style: _getExamNameValueTextStyle(context: context),),
                Text('${resultPercentage.toStringAsFixed(2)}%'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

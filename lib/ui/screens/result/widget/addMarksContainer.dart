import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMarksContainer extends StatelessWidget {
  final String title;
  final String alias;
  final String totalMarks;
  final TextEditingController obtainedMarksTextEditingController;
  final bool? isReadOnly;

  const AddMarksContainer(
      {Key? key,
      required this.title,
      required this.alias,
      required this.totalMarks,
      required this.obtainedMarksTextEditingController,
      this.isReadOnly})
      : super(key: key);

  Widget _buildSubjectNameWithObtainedMarksContainer(
      {required BuildContext context,
      required String alias,
      required String studentName,
      required String totalMarks,
      bool? isReadOnly}) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(builder: (context, boxConstraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: boxConstraints.maxWidth * (0.1),
              child: Text(
                alias.toString(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerStart,
              width: boxConstraints.maxWidth * (0.4),
              child: Text(
                studentName,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5))),
              width: boxConstraints.maxWidth * (0.2),
              height: 35,
              padding: EdgeInsets.only(bottom: 6),
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  //allow only one decimal point (.)
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
                ],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12.0,
                ),
                controller: obtainedMarksTextEditingController,
                readOnly: isReadOnly ?? false,
                decoration: InputDecoration(border: InputBorder.none),
                keyboardType: TextInputType.numberWithOptions(
                    decimal: true, signed: false),
              ),
            ),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              width: boxConstraints.maxWidth * (0.2),
              child: Text(
                totalMarks,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 12.0,
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildSubjectNameWithObtainedMarksContainer(
        context: context,
        alias: alias,
        studentName: title,
        totalMarks: totalMarks,
        isReadOnly: isReadOnly);
  }
}

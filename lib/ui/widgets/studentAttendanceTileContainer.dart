import 'package:cached_network_image/cached_network_image.dart';
import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/utils/labelKeys.dart';
import 'package:eschool_teacher/utils/uiUtils.dart';
import 'package:flutter/material.dart';

class StudentAttendanceTileContainer extends StatelessWidget {
  final Student student;
  final Function(int) updateAttendance;
  final bool isPresent;
  const StudentAttendanceTileContainer(
      {Key? key,
      required this.isPresent,
      required this.student,
      required this.updateAttendance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          updateAttendance(student.id);
        },
        child: Container(
          clipBehavior: Clip.none,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.075),
                    offset: Offset(2.5, 2.5),
                    blurRadius: 10,
                    spreadRadius: 0.5)
              ],
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * (0.88),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12.5),
          child: LayoutBuilder(builder: (context, boxConstraints) {
            return Row(
              children: [
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: CachedNetworkImageProvider(student.image),
                        ),
                        borderRadius: BorderRadius.circular(7.5),
                      ),
                      height: 50,
                      width: boxConstraints.maxWidth * (0.175),
                    ),
                    isPresent
                        ? SizedBox()
                        : Container(
                            child: Icon(
                              Icons.close,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.85),
                              borderRadius: BorderRadius.circular(7.5),
                            ),
                            height: 50,
                            width: boxConstraints.maxWidth * (0.175),
                          ),
                  ],
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.045),
                ),
                SizedBox(
                  width: boxConstraints.maxWidth * (0.56),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.getFullName(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13.0),
                      ),
                      Text(
                          "${UiUtils.getTranslatedLabel(context, rollNoKey)} - ${student.rollNumber}",
                          style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .secondary
                                  .withOpacity(0.75),
                              fontWeight: FontWeight.w400,
                              fontSize: 10.5),
                          textAlign: TextAlign.left)
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2.5),
                  child: Text(
                    UiUtils.getTranslatedLabel(
                        context, isPresent ? presentKey : absentKey),
                    style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).scaffoldBackgroundColor),
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.transparent),
                      color: isPresent
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.error),
                  width: boxConstraints.maxWidth * (0.22),
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}

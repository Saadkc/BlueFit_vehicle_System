import 'package:eschool_teacher/data/models/classSectionDetails.dart';
import 'package:eschool_teacher/data/models/subject.dart';

class TimeTableSlot {
  TimeTableSlot(
      {required this.startTime,
      required this.endTime,
      required this.day,
      required this.dayName,
      required this.subject,
      required this.classSectionDetails});
  late final String startTime;
  late final String endTime;
  late final int day;
  late final String dayName;
  late final Subject subject;
  late final ClassSectionDetails classSectionDetails;

  TimeTableSlot.fromJson(Map<String, dynamic> json) {
    startTime = json['start_time'] ?? "";
    endTime = json['end_time'] ?? "";
    day = json['day'] ?? 0;
    dayName = json['day_name'] ?? "";
    classSectionDetails =
        ClassSectionDetails.fromJson(Map.from(json['class_section'] ?? {}));

    subject = Subject.fromJson(Map.from(json['subject']['subject'] ?? {}));
  }
}

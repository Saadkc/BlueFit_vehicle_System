import 'package:eschool_teacher/data/models/classDetails.dart';
import 'package:eschool_teacher/data/models/sectionDetails.dart';

class ClassSectionDetails {
  final int classTeacherId;
  final int id;
  final ClassDetails classDetails;
  final SectionDetails sectionDetails;

  ClassSectionDetails(
      {required this.classTeacherId,
      required this.id,
      required this.classDetails,
      required this.sectionDetails});

  String getClassSectionName() {
    return "${this.classDetails.name} - ${this.sectionDetails.name}";
  }

  static ClassSectionDetails fromJson(Map<String, dynamic> json) {
    return ClassSectionDetails(
      sectionDetails: SectionDetails.fromJson(Map.from(json['section'])),
      classDetails: ClassDetails.fromJson(Map.from(json['class'])),
      id: json['id'] ?? 0,
      classTeacherId: json['class_teacher_id'] ?? 0,
    );
  }
}

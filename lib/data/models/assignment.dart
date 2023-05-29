import 'package:eschool_teacher/data/models/studyMaterial.dart';
import 'package:eschool_teacher/data/models/subject.dart';

class Assignment {
  Assignment({
    required this.id,
    required this.classSectionId,
    required this.subjectId,
    required this.name,
    required this.instructions,
    required this.dueDate,
    required this.points,
    required this.resubmission,
    required this.extraDaysForResubmission,
    required this.sessionYearId,
    required this.createdAt,
    required this.classSection,
    required this.studyMaterial,
    required this.subject,
  });
  late final int id;
  late final int classSectionId;
  late final int subjectId;
  late final String name;
  late final String instructions;
  late final DateTime dueDate;
  late final int points;
  late final int resubmission;
  late final int extraDaysForResubmission;
  late final int sessionYearId;
  late final String createdAt;
  late final ClassSection classSection;
  late final List<StudyMaterial> studyMaterial;
  late final Subject subject;

  Assignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    classSectionId = json['class_section_id'] ?? 0;
    subjectId = json['subject_id'] ?? 0;
    name = json['name'] ?? "";
    instructions = json["instructions"] ?? "";
    dueDate = DateTime.parse(json['due_date'] ?? "");
    points = json["points"] ?? 0;
    resubmission = json['resubmission'] ?? 0;
    extraDaysForResubmission = json["extra_days_for_resubmission"] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    createdAt = json['created_at'] ?? "";
    classSection = ClassSection.fromJson(json['class_section'] ?? {});
    studyMaterial = ((json['file'] ?? {}) as List)
        .map((e) => StudyMaterial.fromJson(Map.from(e)))
        .toList();
    // file = List.castFrom<dynamic, dynamic>(json['file']);
    subject = Subject.fromJson(json['subject'] ?? {});
  }
}

class ClassSection {
  ClassSection({
    required this.id,
    required this.classId,
    required this.sectionId,
    required this.classTeacherId,
    required this.classs,
    required this.section,
  });
  late final int id;
  late final int classId;
  late final int sectionId;
  late final int classTeacherId;
  late final Classs classs;
  late final Section section;

  ClassSection.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classId = json['class_id'] ?? 0;
    sectionId = json['section_id'] ?? 0;
    classTeacherId = json['class_teacher_id'] ?? 0;
    classs = Classs.fromJson(json['class'] ?? {});
    section = Section.fromJson(json['section'] ?? {});
  }
}

class Classs {
  Classs({
    required this.id,
    required this.name,
    required this.mediumId,
  });
  late final int id;
  late final String name;
  late final int mediumId;

  Classs.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    mediumId = json['medium_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['medium_id'] = mediumId;
    return _data;
  }
}

class Section {
  Section({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
  }
}


// class StudyMaterial {
//   StudyMaterial({
//     required this.id,
//     required this.modalType,
//     required this.modalId,
//     required this.fileName,
//     required this.fileThumbnail,
//     required this.type,
//     required this.fileUrl,
//     required this.fileExtension,
//     required this.typeDetail,
//   });
//   late final int id;
//   late final String modalType;
//   late final int modalId;
//   late final String fileName;
//   late final String fileThumbnail;
//   late final String type;
//   late final String fileUrl;
//   late final String fileExtension;
//   late final String typeDetail;

//   StudyMaterial.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modalType = json['modal_type'];
//     modalId = json['modal_id'];
//     fileName = json['file_name'];
//     fileThumbnail = json['file_thumbnail'];
//     type = json['type'];
//     fileUrl = json['file_url'];
//     fileExtension = json['file_extension'];
//     typeDetail = json['type_detail'];
//   }
// }

// {
//                         "id": 47,
//                         "modal_type": "App\\Models\\Assignment",
//                         "modal_id": 38,
//                         "file_name": "wp4855547.webp",
//                         "file_thumbnail": "",
//                         "type": "1",
//                         "file_url": "https://testschool.wrteam.in/storage/assignment/55v9LeS6NJIOgsV4igmH6Vu6cqcLGvUOxQig0hSn.webp",
//                         "file_extension": "webp",
//                         "type_detail": "File Upload"
//                     },

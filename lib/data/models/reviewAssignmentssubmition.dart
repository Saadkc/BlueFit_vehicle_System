import 'package:eschool_teacher/data/models/studyMaterial.dart';

class ReviewAssignmentssubmition {
  ReviewAssignmentssubmition({
    required this.id,
    required this.assignmentId,
    required this.studentId,
    required this.sessionYearId,
    required this.feedback,
    required this.points,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.assignment,
    required this.student,
    required this.file,
  });
  late final int id;
  late final int assignmentId;
  late final int studentId;
  late final int sessionYearId;
  late final String feedback;
  late final int points;
  late final int status;
  late final String createdAt;
  late final String updatedAt;
  late final String deletedAt;
  late final ReviewAssignment assignment;
  late final ReviewAssignmentStudent student;
  late final List<StudyMaterial> file;

  ReviewAssignmentssubmition.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    assignmentId = json['assignment_id'] ?? 0;
    studentId = json['student_id'] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    feedback = json['feedback'] ?? "";
    points = json['points'] ?? 0;
    status = json['status'] ?? 0;
    createdAt = json['created_at'] ?? "";
    updatedAt = json['updated_at'] ?? "";
    deletedAt = json['deleted_at'] ?? "";
    assignment = ReviewAssignment.fromJson(json['assignment'] ?? {});
    student = ReviewAssignmentStudent.fromJson(json['student'] ?? {});
    file = List.from(json['file'] ?? [])
        .map((e) => StudyMaterial.fromJson(e))
        .toList();
  }

  ReviewAssignmentssubmition copywith(
      {int? status, String? feedback, int? points, int? id}) {
    return ReviewAssignmentssubmition(
        id: id ?? this.id,
        assignmentId: assignmentId,
        studentId: studentId,
        sessionYearId: sessionYearId,
        feedback: feedback ?? this.feedback,
        points: points ?? this.points,
        status: status ?? this.status,
        createdAt: createdAt,
        updatedAt: updatedAt,
        deletedAt: deletedAt,
        assignment: assignment,
        student: student,
        file: file);
  }
}

class ReviewAssignment {
  ReviewAssignment({
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
    required this.subject,
  });
  late final int id;
  late final int classSectionId;
  late final int subjectId;
  late final String name;
  late final String instructions;
  late final String dueDate;
  late final int points;
  late final int resubmission;
  late final int extraDaysForResubmission;
  late final int sessionYearId;
  late final String createdAt;
  late final ReviewAssignmentSubject subject;

  ReviewAssignment.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    classSectionId = json['class_section_id'] ?? 0;
    subjectId = json['subject_id'] ?? 0;
    name = json['name'] ?? "";
    instructions = json['instructions'] ?? "";
    dueDate = json['due_date'] ?? "";
    points = json['points'] ?? 0;
    resubmission = json['resubmission'] ?? 0;
    extraDaysForResubmission = json['extra_days_for_resubmission'] ?? 0;
    sessionYearId = json['session_year_id'] ?? 0;
    createdAt = json['created_at'] ?? "";
    subject = ReviewAssignmentSubject.fromJson(json['subject'] ?? {});
  }
}

class ReviewAssignmentSubject {
  ReviewAssignmentSubject({
    required this.id,
    required this.name,
  });
  late final int id;
  late final String name;

  ReviewAssignmentSubject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'];
  }
}

class ReviewAssignmentStudent {
  ReviewAssignmentStudent({
    required this.id,
    required this.userId,
    required this.user,
  });
  late final int id;
  late final int userId;
  late final User user;

  ReviewAssignmentStudent.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    user = User.fromJson(json['user'] ?? {});
  }
}

class User {
  User({
    required this.firstName,
    required this.lastName,
    required this.id,
    required this.image,
  });

  late final String firstName;
  late final String lastName;
  late final int id;
  late final String image;

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    image = json['image'] ?? "";
    id = json['id'] ?? 0;
  }
}

class File {
  File({
    required this.id,
    required this.modalType,
    required this.modalId,
    required this.fileName,
    required this.fileThumbnail,
    required this.type,
    required this.fileUrl,
    required this.fileExtension,
    required this.typeDetail,
  });
  late final int id;
  late final String modalType;
  late final int modalId;
  late final String fileName;
  late final String fileThumbnail;
  late final String type;
  late final String fileUrl;
  late final String fileExtension;
  late final String typeDetail;

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    modalType = json['modal_type'] ?? "";
    modalId = json['modal_id'] ?? 0;
    fileName = json['file_name'] ?? "";
    fileThumbnail = json['file_thumbnail'] ?? "";
    type = json['type'] ?? "";
    fileUrl = json['file_url'] ?? "";
    fileExtension = json['file_extension'] ?? "";
    typeDetail = json['type_detail'] ?? "";
  }
}

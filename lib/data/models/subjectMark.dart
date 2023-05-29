
class SubjectMark {
  // final Subject subject;
  final int totalMarks;
  final String subjectName;
  final String subjectType;
  final int obtainedMarks;
  final String grade;

  // final int passingStatus;
  // final int passingMarks;
  // final DateTime examDate;

  SubjectMark({required this.grade,
    //required this.examDate,
    // required this.passingStatus,
    required this.obtainedMarks,
    required this.subjectName,
    required this.subjectType,
    // required this.subject,
    // required this.passingMarks,
    required this.totalMarks
  });

  static SubjectMark fromJson(Map<String, dynamic> json) {
    return SubjectMark(
      grade: json['grade'] ?? "",
      obtainedMarks: json['obtained_marks'] ?? 0,
      totalMarks: json['total_marks'] ?? 0,
      subjectName: json['subject_name'] ?? '',
      subjectType: json['subject_type'] ?? '',
      // subject: Subject.fromJson(Map.from(json['subject'] ?? {})),
      /*      passingStatus: json['passing_status'] ?? -1,
        passingMarks: json['passing_marks'] ?? 0,
        examDate: json['timetable'] == null
            ? DateTime.now()
            : json['timetable']['date'] == null
                ? DateTime.now()
                : DateTime.parse(json['timetable']['date']),*/);
  }
}

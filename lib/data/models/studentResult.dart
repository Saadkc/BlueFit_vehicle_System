class StudentResult {
  int? examId;
  String? examName;
  String? examDate;
  List<MarksData>? marksData;
  ResultData? result;

  StudentResult(
      {this.examId, this.examName, this.marksData, this.result, this.examDate});

  StudentResult.fromJson(Map<String, dynamic> json) {
    examId = json['exam_id'] ?? 0;
    examName = json['exam_name'] ?? '';
    examDate = json['exam_date'] ?? '';
    if (json['marks_data'] != null) {
      marksData = <MarksData>[];
      json['marks_data'].forEach((v) {
        marksData!.add(MarksData.fromJson(v));
      });
    }
    result =
        json['result'] != null ? ResultData.fromJson(json['result']) : null;
  }
}

class MarksData {
  int? subjectId;
  String? subjectName;
  String? subjectType;
  String? subjectCode;
  String? totalMarks;
  Marks? marks;

  MarksData(
      {this.subjectId,
      this.subjectName,
      this.marks,
      this.totalMarks,
      this.subjectType,
      this.subjectCode});

  MarksData.fromJson(Map<String, dynamic> json) {
    subjectId = json['subject_id'] ?? 0;
    subjectName = json['subject_name'] ?? '';
    totalMarks = (json['total_marks'] ?? "").toString();
    subjectType = json['subject_type'] ?? '';
    subjectCode = json['subject_code'] ?? '';
    marks = json['marks'] != null ? Marks.fromJson(json['marks']) : null;
  }
}

class Marks {
  int? marksId;
  String? subjectName;
  String? subjectType;
  int? totalMarks;
  int? obtainedMarks;
  String? grade;

  Marks(
      {this.marksId,
      this.subjectName,
      this.subjectType,
      this.totalMarks,
      this.obtainedMarks,
      this.grade});

  Marks.fromJson(Map<String, dynamic> json) {
    marksId = json['marks_id'] ?? 0;
    subjectName = json['subject_name'] ?? '';
    subjectType = json['subject_type'] ?? '';
    totalMarks = json['total_marks'] ?? -1;
    obtainedMarks = json['obtained_marks'] ?? -1;
    grade = json['grade'] ?? '';
  }
}

class ResultData {
  int? resultId;
  int? examId;
  String? examName;
  String? className;
  String? studentName;
  String? examDate;
  int? totalMarks;
  int? obtainedMarks;
  double? percentage;
  String? grade;
  String? sessionYear;

  ResultData(
      {this.resultId,
      this.examId,
      this.examName,
      this.className,
      this.studentName,
      this.examDate,
      this.totalMarks,
      this.obtainedMarks,
      this.percentage,
      this.grade,
      this.sessionYear});

  ResultData.fromJson(Map<String, dynamic> json) {
    resultId = json['result_id'] ?? 0;
    examId = json['exam_id'] ?? 0;
    examName = json['exam_name'] ?? '';
    className = json['class_name'] ?? '';
    studentName = json['student_name'] ?? '';
    examDate = json['exam_date'] ?? '';
    totalMarks = json['total_marks'] ?? 0;
    obtainedMarks = json['obtained_marks'] ?? 0;
    percentage = json['percentage'] != null
        ? double.parse(json['percentage'].toString())
        : 0;
    grade = json['grade'] ?? '';
    sessionYear = json['session_year'] ?? '';
  }
}

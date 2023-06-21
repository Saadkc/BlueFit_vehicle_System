class ResultOnlineDetails {
  ResultOnlineDetails({
    this.totalQuestions,
    this.correctAnswers,
    this.inCorrectAnswers,
    this.totalObtainedMarks,
    this.totalMarks,
  });

  late final int? totalQuestions;
  late final ResultAnswers? correctAnswers;
  late final ResultAnswers? inCorrectAnswers;
  late final String? totalObtainedMarks;
  late final String? totalMarks;

  ResultOnlineDetails.fromJson(Map<String, dynamic> json) {
    totalQuestions = json['total_questions'];
    correctAnswers = json['correct_answers'] != null
        ? ResultAnswers.fromJson(json['correct_answers'])
        : null;
    inCorrectAnswers = json['in_correct_answers'] != null
        ? ResultAnswers.fromJson(json['in_correct_answers'])
        : null;
    totalObtainedMarks = json['total_obtained_marks'];
    totalMarks = json['total_marks'];
  }
}

class ResultAnswers {
  int? totalQuestions;
  List<QuestionData>? questionData;

  ResultAnswers({this.totalQuestions, this.questionData});

  ResultAnswers.fromJson(Map<String, dynamic> json) {
    totalQuestions = json['total_questions'];
    if (json['question_data'] != null) {
      questionData = <QuestionData>[];
      json['question_data'].forEach((v) {
        questionData!.add(QuestionData.fromJson(v));
      });
    }
  }
}

class QuestionData {
  int? questionId;
  int? marks;

  QuestionData({this.questionId, this.marks});

  QuestionData.fromJson(Map<String, dynamic> json) {
    questionId = json['question_id'];
    marks = json['marks'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['question_id'] = this.questionId;
    data['marks'] = this.marks;
    return data;
  }
}

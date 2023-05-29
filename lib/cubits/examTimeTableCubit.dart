import 'package:eschool_teacher/data/models/exam.dart';
import 'package:eschool_teacher/data/models/subject.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/repositories/studentRepository.dart';

abstract class ExamTimeTableState {}

class ExamTimeTableInitial extends ExamTimeTableState {}

class ExamTimeTableFetchSuccess extends ExamTimeTableState {
  final List<ExamTimeTable> examTimeTableList;

  ExamTimeTableFetchSuccess({required this.examTimeTableList});
}

class ExamTimeTableFetchFailure extends ExamTimeTableState {
  final String errorMessage;

  ExamTimeTableFetchFailure(this.errorMessage);
}

class ExamTimeTableFetchInProgress extends ExamTimeTableState {}

class ExamTimeTableCubit extends Cubit<ExamTimeTableState> {
  final StudentRepository _studentRepository;

  ExamTimeTableCubit(this._studentRepository) : super(ExamTimeTableInitial());

  void fetchStudentExamTimeTable({required int examID}) {
    emit(ExamTimeTableFetchInProgress());
    _studentRepository
        .fetchExamTimeTable(
          examId: examID,
        )
        .then((value) =>
            emit(ExamTimeTableFetchSuccess(examTimeTableList: value)))
        .catchError((e) => emit(ExamTimeTableFetchFailure(e.toString())));
  }


  void updateState(ExamTimeTableState updateState) {
    emit(updateState);
  }
  List<ExamTimeTable> getAllSubjectOfExamTimeTable() {
    if (state is ExamTimeTableFetchSuccess) {
      return (state as ExamTimeTableFetchSuccess).examTimeTableList;
    }
    return [];
  }

  List<Subject> getAllSubjects() {
    var list = List<Subject>.from(
        getAllSubjectOfExamTimeTable().map((e) => e.subject));

    return list;
  }

  String getTotalMarksOfSubject({required int subjectId}) {
    String totalMarks = '';
    getAllSubjectOfExamTimeTable().forEach((element) {
      if(element.subject!.id == subjectId){
        totalMarks= element.totalMarks.toString();
      }
    });

    return totalMarks;
  }

  List<String> getSubjectName() {
    return getAllSubjects().map((exams) => exams.getSubjectName()).toList();
  }

  Subject getSubjectDetailsBySubjectName({required String subjectName}) {
    return getAllSubjects()
        .where((element) => element.name == subjectName.trim())
        .first;
  }
}

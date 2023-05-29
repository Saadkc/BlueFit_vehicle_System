import 'package:eschool_teacher/data/models/studentResult.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentCompletedExamWithResultState {}

class StudentCompletedExamWithResultInitial
    extends StudentCompletedExamWithResultState {}

class StudentCompletedExamWithResultFetchInProgress
    extends StudentCompletedExamWithResultState {}

class StudentCompletedExamWithResultFetchSuccess
    extends StudentCompletedExamWithResultState {
  final List<StudentResult> studentCompletedExamWithResultList;

  StudentCompletedExamWithResultFetchSuccess(
      {required this.studentCompletedExamWithResultList});
}

class StudentCompletedExamWithResultFetchFailure
    extends StudentCompletedExamWithResultState {
  final String errorMessage;

  StudentCompletedExamWithResultFetchFailure(this.errorMessage);
}

class StudentCompletedExamWithResultCubit
    extends Cubit<StudentCompletedExamWithResultState> {
  final StudentRepository _studentRepository;

  StudentCompletedExamWithResultCubit(this._studentRepository)
      : super(StudentCompletedExamWithResultInitial());

  void fetchStudentCompletedExamWithResult({required int studentId}) async {
    try {
      print('calling');
      emit(StudentCompletedExamWithResultFetchInProgress());
      var result = await _studentRepository
          .fetchStudentCompletedExamListWithResult(studentId: studentId);

      emit(StudentCompletedExamWithResultFetchSuccess(
          studentCompletedExamWithResultList:
              result));
    } catch (e) {
      emit(StudentCompletedExamWithResultFetchFailure(e.toString()));
    }
  }
}

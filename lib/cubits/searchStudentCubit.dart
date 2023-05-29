import 'package:eschool_teacher/data/models/student.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SearchStudentState {}

class SearchStudentInitial extends SearchStudentState {}

class SearchStudentInProgress extends SearchStudentState {}

class SearchStudentSuccess extends SearchStudentState {
  final List<Student> students;
  SearchStudentSuccess(this.students);
}

class SearchStudentFailure extends SearchStudentState {
  final String errorMessage;

  SearchStudentFailure(this.errorMessage);
}

class SearchStudentCubit extends Cubit<SearchStudentState> {
  //late StudentRepository studentRepository;

  SearchStudentCubit() : super(SearchStudentInitial()) {
    //studentRepository = StudentRepository();
  }

  void searchStudent(String searchQuery) {
    emit(SearchStudentInProgress());
    // studentRepository
    //     .searchStudents(searchQuery: searchQuery)
    //     .then((value) => emit(SearchStudentSuccess(value)))
    //     .catchError((e) => emit(SearchStudentFailure(e.toString())));
  }
}

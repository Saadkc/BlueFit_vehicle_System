import 'package:eschool_teacher/data/models/guardianDetails.dart';
import 'package:eschool_teacher/data/repositories/studentRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class StudentMoreDetailsState {}

class StudentMoreDetailsInitial extends StudentMoreDetailsState {}

class StudentMoreDetailsFetchInProgress extends StudentMoreDetailsState {}

class StudentMoreDetailsFetchSuccess extends StudentMoreDetailsState {
  final GuardianDetails fatherDetails;
  final GuardianDetails motherDetails;
  final GuardianDetails guardianDetails;
  final int totalAbsent;
  final int totalPresent;
  final String todayAttendance;

  StudentMoreDetailsFetchSuccess(
      {required this.fatherDetails,
      required this.guardianDetails,
      required this.motherDetails,
      required this.todayAttendance,
      required this.totalAbsent,
      required this.totalPresent});
}

class StudentMoreDetailsFetchFailure extends StudentMoreDetailsState {
  final String errorMessage;

  StudentMoreDetailsFetchFailure(this.errorMessage);
}

class StudentMoreDetailsCubit extends Cubit<StudentMoreDetailsState> {
  final StudentRepository _studentRepository;

  StudentMoreDetailsCubit(this._studentRepository)
      : super(StudentMoreDetailsInitial());

  void fetchStudentMoreDetails({required int studentId}) async {
    emit(StudentMoreDetailsFetchInProgress());
    try {
      final result =
          await _studentRepository.getStudentsMoreDetails(studentId: studentId);
      emit(StudentMoreDetailsFetchSuccess(
          fatherDetails: result['fatherDetails'],
          guardianDetails: result['guardianDetails'],
          motherDetails: result['motherDetails'],
          todayAttendance: result['todayAttendance'],
          totalAbsent: result['totalAbsent'],
          totalPresent: result['totalPresent']));
    } catch (e) {
      emit(StudentMoreDetailsFetchFailure(e.toString()));
    }
  }
}

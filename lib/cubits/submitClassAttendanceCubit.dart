import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SubmitClassAttendanceState {}

class SubmitClassAttendanceInitial extends SubmitClassAttendanceState {}

class SubmitClassAttendanceInProgress extends SubmitClassAttendanceState {}

class SubmitClassAttendanceSuccess extends SubmitClassAttendanceState {}

class SubmitClassAttendanceFailure extends SubmitClassAttendanceState {
  final String errorMessage;

  SubmitClassAttendanceFailure(this.errorMessage);
}

class SubmitClassAttendanceCubit extends Cubit<SubmitClassAttendanceState> {
  final TeacherRepository _teacherRepository;

  SubmitClassAttendanceCubit(this._teacherRepository)
      : super(SubmitClassAttendanceInitial());

  void submitAttendance(
      {required DateTime dateTime,
      required int classSectionId,
      required List<Map<int, bool>> attendanceReport}) async {
    emit(SubmitClassAttendanceInProgress());
    try {
      await _teacherRepository.submitClassAttendance(
          classSectionId: classSectionId,
          date: "${dateTime.year}-${dateTime.month}-${dateTime.day}",
          attendance: attendanceReport
              .map(
                (attendanceReport) => {
                  "student_id": attendanceReport.keys.first,
                  "type": attendanceReport[attendanceReport.keys.first]! ? 1 : 0
                },
              )
              .toList());
      emit(SubmitClassAttendanceSuccess());
    } catch (e) {
      emit(SubmitClassAttendanceFailure(e.toString()));
    }
  }
}

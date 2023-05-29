import 'package:eschool_teacher/data/models/attendanceReport.dart';
import 'package:eschool_teacher/data/models/holiday.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ClassAttendanceState {}

class ClassAttendanceInitial extends ClassAttendanceState {}

class ClassAttendanceFetchInProgress extends ClassAttendanceState {}

class ClassAttendanceFetchSuccess extends ClassAttendanceState {
  final List<AttendanceReport> attendanceReports;
  final bool isHoliday;
  final Holiday holidayDetails;

  ClassAttendanceFetchSuccess(
      {required this.attendanceReports,
      required this.isHoliday,
      required this.holidayDetails});
}

class ClassAttendanceFetchFailure extends ClassAttendanceState {
  final String errorMessage;

  ClassAttendanceFetchFailure(this.errorMessage);
}

class ClassAttendanceCubit extends Cubit<ClassAttendanceState> {
  final TeacherRepository _teacherRepository;

  ClassAttendanceCubit(this._teacherRepository)
      : super(ClassAttendanceInitial());

  void fetchAttendanceReports(
      {required int classSectionId, required DateTime date}) async {
    emit(ClassAttendanceFetchInProgress());
    try {
      final result = await _teacherRepository.getClassAttendanceReports(
          classSectionId: classSectionId,
          date: "${date.year}-${date.month}-${date.day}");

      emit(
        ClassAttendanceFetchSuccess(
          attendanceReports: result['attendanceReports'],
          isHoliday: result['isHoliday'],
          holidayDetails: result['holidayDetails'],
        ),
      );
    } catch (e) {
      emit(ClassAttendanceFetchFailure(e.toString()));
    }
  }
}

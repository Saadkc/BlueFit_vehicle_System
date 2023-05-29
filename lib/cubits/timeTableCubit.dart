import 'package:eschool_teacher/data/models/timeTableSlot.dart';
import 'package:eschool_teacher/data/repositories/teacherRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimeTableState {}

class TimeTableInitial extends TimeTableState {}

class TimeTableFetchInProgress extends TimeTableState {}

class TimeTableFetchSuccess extends TimeTableState {
  final List<TimeTableSlot> timetableSlots;

  TimeTableFetchSuccess(this.timetableSlots);
}

class TimeTableFetchFailure extends TimeTableState {
  final String errorMessage;

  TimeTableFetchFailure(this.errorMessage);
}

class TimeTableCubit extends Cubit<TimeTableState> {
  final TeacherRepository _teacherRepository;

  TimeTableCubit(this._teacherRepository) : super(TimeTableInitial());

  void fetchTimeTable() async {
    emit(TimeTableFetchInProgress());
    try {
      emit(TimeTableFetchSuccess(await _teacherRepository.fetchTimeTable()));
    } catch (e) {
      emit(TimeTableFetchFailure(e.toString()));
    }
  }
}

import 'package:eschool_teacher/data/models/holiday.dart';
import 'package:eschool_teacher/data/repositories/systemInfoRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HolidaysState {}

class HolidaysInitial extends HolidaysState {}

class HolidaysFetchInProgress extends HolidaysState {}

class HolidaysFetchSuccess extends HolidaysState {
  final List<Holiday> holidays;

  HolidaysFetchSuccess({required this.holidays});
}

class HolidaysFetchFailure extends HolidaysState {
  final String errorMessage;

  HolidaysFetchFailure(this.errorMessage);
}

class HolidaysCubit extends Cubit<HolidaysState> {
  final SystemRepository _systemRepository;

  HolidaysCubit(this._systemRepository) : super(HolidaysInitial());

  void fetchHolidays() async {
    emit(HolidaysFetchInProgress());
    try {
      emit(HolidaysFetchSuccess(
          holidays: await _systemRepository.fetchHolidays()));
    } catch (e) {
      emit(HolidaysFetchFailure(e.toString()));
    }
  }

  List<Holiday> holidays() {
    if (state is HolidaysFetchSuccess) {
      return (state as HolidaysFetchSuccess).holidays;
    }
    return [];
  }
}

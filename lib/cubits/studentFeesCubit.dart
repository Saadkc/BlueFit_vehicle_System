import 'package:bloc/bloc.dart';
import 'package:eschool/data/models/paidFees.dart';
import 'package:eschool/data/repositories/studentRepository.dart';

abstract class StudentFeesState {}

class StudentFeesInitial extends StudentFeesState {}

class StudentFeesFetchSuccess extends StudentFeesState {
  final List<PaidFees> feesList;

  StudentFeesFetchSuccess({required this.feesList});
}

class StudentFeesFetchFailure extends StudentFeesState {
  final String errorMessage;

  StudentFeesFetchFailure(this.errorMessage);
}

class StudentFeesFetchInProgress extends StudentFeesState {}

class StudentFeesCubit extends Cubit<StudentFeesState> {
  final StudentRepository _studentRepository;

  StudentFeesCubit(this._studentRepository) : super(StudentFeesInitial());

  void fetchStudentFeesList({int? childId}) {
    emit(StudentFeesFetchInProgress());
    _studentRepository
        .fetchFeesList(childId: childId ?? 0)
        .then((value) => emit(StudentFeesFetchSuccess(feesList: value)))
        .catchError((e) => emit(StudentFeesFetchFailure(e.toString())));
  }
}

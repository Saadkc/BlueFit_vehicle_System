import 'package:bloc/bloc.dart';
import 'package:eschool/data/models/fees.dart';
import 'package:eschool/data/repositories/studentRepository.dart';

abstract class StudentDetailedFeesState {}

class StudentDetailedFeesInitial extends StudentDetailedFeesState {}

class StudentDetailedFeesFetchSuccess extends StudentDetailedFeesState {
  final List<Fees> feesDetails;

  StudentDetailedFeesFetchSuccess({required this.feesDetails});
}

class StudentDetailedFeesFetchFailure extends StudentDetailedFeesState {
  final String errorMessage;

  StudentDetailedFeesFetchFailure(this.errorMessage);
}

class StudentDetailedFeesFetchInProgress extends StudentDetailedFeesState {}

class StudentDetailedFeesCubit extends Cubit<StudentDetailedFeesState> {
  final StudentRepository _studentRepository;

  StudentDetailedFeesCubit(this._studentRepository)
      : super(StudentDetailedFeesInitial());

  void fetchDetailedFees({int? classSectionId}) {
    emit(StudentDetailedFeesFetchInProgress());
    _studentRepository
        .fetchDetailedFees(classSectionId: classSectionId ?? 0)
        .then((value) =>
            emit(StudentDetailedFeesFetchSuccess(feesDetails: value)))
        .catchError((e) => emit(StudentDetailedFeesFetchFailure(e.toString())));
  }

  List<Fees> getFees() {
    if (state is StudentDetailedFeesFetchSuccess) {
      return (state as StudentDetailedFeesFetchSuccess).feesDetails;
    }
    return [];
  }
}

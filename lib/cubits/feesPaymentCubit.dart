import 'package:bloc/bloc.dart';
import 'package:eschool/data/repositories/studentRepository.dart';

abstract class FeesPaymentState {}

class FeesPaymentInitial extends FeesPaymentState {}

class FeesPaymentFetchSuccess extends FeesPaymentState {
  final Map paymentGatewayDetails;
  FeesPaymentFetchSuccess(this.paymentGatewayDetails);
}

class FeesPaymentFetchFailure extends FeesPaymentState {
  final String errorMessage;

  FeesPaymentFetchFailure(this.errorMessage);
}

class FeesPaymentFetchInProgress extends FeesPaymentState {}

class FeesPaymentCubit extends Cubit<FeesPaymentState> {
  final StudentRepository _studentRepository;

  FeesPaymentCubit(this._studentRepository) : super(FeesPaymentInitial());

  void setFeesChoices(
      {required List<int> selectedChoice, required int childId}) {
    emit(FeesPaymentFetchInProgress());
    _studentRepository
        .setFeesChoices(types: selectedChoice, childId: childId)
        .then((value) => emit(FeesPaymentFetchSuccess(value)))
        .catchError((e) => emit(FeesPaymentFetchFailure(e.toString())));
  }
}

import 'package:bloc/bloc.dart';
import 'package:eschool/data/models/paidFees.dart';
import 'package:eschool/data/repositories/studentRepository.dart';

abstract class FeesReceiptState {}

class FeesReceiptInitial extends FeesReceiptState {}

class FeesReceiptSendSuccess extends FeesReceiptState {
  final String successMessage;
  FeesReceiptSendSuccess(this.successMessage);
}

class FeesReceiptSendFailure extends FeesReceiptState {
  final String errorMessage;

  FeesReceiptSendFailure(this.errorMessage);
}

class FeesReceiptSendInProgress extends FeesReceiptState {
  final List<PaidFees> receiptList;
  FeesReceiptSendInProgress(this.receiptList);
}

class FeesReceiptCubit extends Cubit<FeesReceiptState> {
  final StudentRepository _studentRepository;

  FeesReceiptCubit(this._studentRepository) : super(FeesReceiptInitial());

  void sendFeesReceipt(
      {required int feesPaidId, required List<PaidFees> receiptList}) {
    receiptList.firstWhere((element) => element.id == feesPaidId).isProcessing =
        true; //update value of list element isProcessing
    emit(FeesReceiptSendInProgress(receiptList));
    _studentRepository
        .sendFeesReceipt(feesPaidId: feesPaidId)
        .then((value) => emit(FeesReceiptSendSuccess(value)))
        .catchError((e) => emit(FeesReceiptSendFailure(e.toString())));
  }
}

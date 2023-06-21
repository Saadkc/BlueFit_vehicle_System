import 'package:bloc/bloc.dart';
import 'package:eschool/data/repositories/studentRepository.dart';
import 'package:eschool/utils/stripeService.dart';

abstract class PostFeesPaymentState {}

class PostFeesPaymentInitial extends PostFeesPaymentState {}

class PostFeesPaymentSuccess extends PostFeesPaymentState {}

class PostFeesPaymentFailure extends PostFeesPaymentState {
  final String errorMessage;

  PostFeesPaymentFailure(this.errorMessage);
}

class PostFeesPaymentInProgress extends PostFeesPaymentState {}

class PostFeesPaymentCubit extends Cubit<PostFeesPaymentState> {
  final StudentRepository _studentRepository;

  PostFeesPaymentCubit(this._studentRepository)
      : super(PostFeesPaymentInitial());

  void setFeesPaymentStatus(
      {required String transactionId,
      required int childId,
      required bool verifyStripePaymentIntent,
      String? stripePaymentSecretKey,
      String? paymentIntentId,
      String? paymentId,
      String? paymentSignature}) async {
    emit(PostFeesPaymentInProgress());
    try {
      if (verifyStripePaymentIntent) {
        final paymentIntentStatus =
            await _studentRepository.confirmStripePayment(
                paymentIntentId: paymentIntentId ?? "",
                paymentSecretKey: stripePaymentSecretKey ?? "");

        if (paymentIntentStatus != StripeService.paymentIntentSuccessResponse) {
          throw Exception("Payment failed");
        }
      }

      await _studentRepository.setFeesTransactionStatus(
          childId: childId,
          transactionId: transactionId,
          paymentId: paymentId,
          paymentSignature: paymentSignature);
      emit(PostFeesPaymentSuccess());
    } catch (e) {
      emit(PostFeesPaymentFailure(e.toString()));
    }
  }
}

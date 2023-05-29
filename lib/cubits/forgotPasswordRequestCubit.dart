import 'package:eschool_teacher/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ForgotPasswordRequestState {}

class ForgotPasswordRequestInitial extends ForgotPasswordRequestState {}

class ForgotPasswordRequestInProgress extends ForgotPasswordRequestState {}

class ForgotPasswordRequestSuccess extends ForgotPasswordRequestState {}

class ForgotPasswordRequestFailure extends ForgotPasswordRequestState {
  final String errorMessage;

  ForgotPasswordRequestFailure(this.errorMessage);
}

class ForgotPasswordRequestCubit extends Cubit<ForgotPasswordRequestState> {
  final AuthRepository _authRepository;

  ForgotPasswordRequestCubit(this._authRepository)
      : super(ForgotPasswordRequestInitial());

  void requestforgotPassword({required String email}) async {
    emit(ForgotPasswordRequestInProgress());
    try {
      await _authRepository.forgotPassword(email: email);
      emit(ForgotPasswordRequestSuccess());
    } catch (e) {
      emit(ForgotPasswordRequestFailure(e.toString()));
    }
  }
}

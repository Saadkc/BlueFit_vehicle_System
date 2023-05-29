import 'package:eschool_teacher/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordInProgress extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String errorMessage;

  ChangePasswordFailure(this.errorMessage);
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final AuthRepository _authRepository;

  ChangePasswordCubit(this._authRepository) : super(ChangePasswordInitial());

  void changePassword(
      {required String currentPassword,
      required String newPassword,
      required String newConfirmedPassword}) async {
    emit(ChangePasswordInProgress());
    try {
      await _authRepository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
          newConfirmedPassword: newConfirmedPassword);
      emit(ChangePasswordSuccess());
    } catch (e) {
      emit(ChangePasswordFailure(e.toString()));
    }
  }
}

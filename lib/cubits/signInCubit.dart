import 'package:eschool_teacher/data/models/teacher.dart';
import 'package:eschool_teacher/data/repositories/authRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {}

class SignInSuccess extends SignInState {
  final String jwtToken;
  final Teacher teacher;

  SignInSuccess({required this.jwtToken, required this.teacher});
}

class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure(this.errorMessage);
}

class SignInCubit extends Cubit<SignInState> {
  final AuthRepository _authRepository;

  SignInCubit(this._authRepository) : super(SignInInitial());

  void signInUser({required String email, required String password}) async {
    emit(SignInInProgress());

    try {
      Map<String, dynamic> result =
          await _authRepository.signInTeacher(email: email, password: password);

      emit(SignInSuccess(
        jwtToken: result['jwtToken'],
        teacher: result['teacher'] as Teacher,
      ));
    } catch (e) {
      print(e.toString());
      emit(SignInFailure(e.toString()));
    }
  }
}

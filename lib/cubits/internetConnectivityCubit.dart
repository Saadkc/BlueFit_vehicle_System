import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class InternetConnectivityState {}

class InternetConnectivityInitial extends InternetConnectivityState {}

class InternetConnectivityEstablished extends InternetConnectivityState {
  final bool isUserOnline;

  InternetConnectivityEstablished({required this.isUserOnline});
}

class InternetConnectivityCubit extends Cubit<InternetConnectivityState> {
  InternetConnectivityCubit() : super(InternetConnectivityInitial()) {
    _setUpInternetConnectionChecker();
  }

  StreamSubscription<ConnectivityResult>? _streamSubscription;

  void _setUpInternetConnectionChecker() async {
    _streamSubscription = Connectivity()
        .onConnectivityChanged
        .listen(_internetConnectionListenerCallback);
  }

  Future<void> _internetConnectionListenerCallback(
      ConnectivityResult result) async {
    //
    if (result != ConnectivityResult.none) {
      bool hasConnection = await InternetConnectionChecker().hasConnection;

      if (state is InternetConnectivityInitial) {
        emit(InternetConnectivityEstablished(isUserOnline: hasConnection));
      } else {
        //do not emit state with same data
        if ((state as InternetConnectivityEstablished).isUserOnline !=
            hasConnection) {
          emit(InternetConnectivityEstablished(isUserOnline: hasConnection));
        }
      }
    } else {
      emit(InternetConnectivityEstablished(isUserOnline: false));
    }
  }

  Future<void> close() async {
    _streamSubscription?.cancel();
    return super.close();
  }
}

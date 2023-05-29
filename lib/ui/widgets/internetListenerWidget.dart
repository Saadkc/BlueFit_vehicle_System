import 'package:eschool_teacher/cubits/internetConnectivityCubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InternetListenerWidget extends StatelessWidget {
  final Widget child;
  final Function onInternetConnectionBack;
  final Function? addOverlay;
  final Function? removeOverlay;
  final bool? showOverlay;

  const InternetListenerWidget(
      {Key? key,
      required this.child,
      required this.onInternetConnectionBack,
      this.addOverlay,
      this.removeOverlay,
      this.showOverlay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetConnectivityCubit, InternetConnectivityState>(
      bloc: context.read<InternetConnectivityCubit>(),
      listener: (context, state) {
        if (state is InternetConnectivityEstablished) {
          //user is online
          if (state.isUserOnline) {
            onInternetConnectionBack();
          }

          if (showOverlay ?? false) {
            //remove overlay
            if (state.isUserOnline) {
              removeOverlay?.call();
            } else {
              addOverlay?.call();
            }
          }
        }
      },
      child: child,
    );
  }
}

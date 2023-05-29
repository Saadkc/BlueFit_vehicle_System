import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Function onRefreshCallback;
  final double displacment;
  CustomRefreshIndicator(
      {Key? key,
      required this.child,
      required this.displacment,
      required this.onRefreshCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: child,
        displacement: displacment,
        onRefresh: () async {
          onRefreshCallback();
        });
  }
}

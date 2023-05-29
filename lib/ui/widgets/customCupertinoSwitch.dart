import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertinoSwitch extends StatelessWidget {
  final Function onChanged;
  final bool value;

  const CustomCupertinoSwitch(
      {Key? key, required this.onChanged, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
        scale: 0.65,
        child: CupertinoSwitch(
            activeColor: Theme.of(context).colorScheme.primary,
            value: value,
            onChanged: (value) {
              onChanged(value);
            }));
  }
}

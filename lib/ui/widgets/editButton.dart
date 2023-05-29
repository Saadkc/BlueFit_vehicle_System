import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function onTap;
  const EditButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Icon(
        Icons.edit,
        size: 22.5,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}

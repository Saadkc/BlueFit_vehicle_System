import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function onTap;
  const DeleteButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Icon(
        Icons.delete,
        size: 22.5,
        color: Theme.of(context).colorScheme.error,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      onTap: () {},
      child: Container(
        alignment: Alignment.center,
        width: 30,
        height: 30,
        child: Icon(
          Icons.share_outlined,
          size: 15,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle),
      ),
    );
  }
}

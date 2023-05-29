import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BottomsheetAddFilesDottedBorderContainer extends StatelessWidget {
  final String title;
  final Function onTap;
  const BottomsheetAddFilesDottedBorderContainer(
      {Key? key, required this.onTap, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [10, 10],
        radius: Radius.circular(10.0),
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
        child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 15,
                          offset: Offset(0, 2.0),
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.25))
                    ]),
                width: 30,
                height: 30,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * (0.05),
              ),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ],
          ),
          height: MediaQuery.of(context).size.height * (0.075),
        ),
      ),
    );
  }
}

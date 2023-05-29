import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddedFileContainer extends StatelessWidget {
  final PlatformFile platformFile;
  final Function onDelete;
  const AddedFileContainer(
      {Key? key, required this.onDelete, required this.platformFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return DottedBorder(
        borderType: BorderType.RRect,
        dashPattern: [10, 10],
        radius: Radius.circular(10.0),
        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.3),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 10),
          child: Row(
            children: [
              SizedBox(
                width: boxConstraints.maxWidth * (0.75),
                child: Text(
                  platformFile.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Spacer(),
              IconButton(
                  onPressed: () {
                    onDelete();
                  },
                  icon: Icon(Icons.close)),
            ],
          ),
        ),
      );
    });
  }
}

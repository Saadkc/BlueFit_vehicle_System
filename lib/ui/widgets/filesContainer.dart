import 'package:eschool/data/models/studyMaterial.dart';
import 'package:eschool/ui/widgets/downloadFileButton.dart';
import 'package:eschool/ui/widgets/noDataContainer.dart';
import 'package:eschool/utils/labelKeys.dart';
import 'package:eschool/utils/uiUtils.dart';

import 'package:flutter/material.dart';

class FilesContainer extends StatefulWidget {
  final List<StudyMaterial> files;
  FilesContainer({Key? key, required this.files}) : super(key: key);

  @override
  State<FilesContainer> createState() => _FilesContainerState();
}

class _FilesContainerState extends State<FilesContainer> {
  Widget _buildFileDetailsContainer(StudyMaterial file) {
    return GestureDetector(
      onTap: () {
        UiUtils.openDownloadBottomsheet(
            context: context,
            storeInExternalStorage: false,
            studyMaterial: file);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                offset: Offset(5, 5),
                blurRadius: 10,
                spreadRadius: 0)
          ],
        ),
        height: 60,
        child: LayoutBuilder(builder: (context, boxConstraints) {
          return Row(
            children: [
              SizedBox(
                width: boxConstraints.maxWidth * (0.6),
                child: Text(
                  "${file.fileName}.${file.fileExtension}",
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.w500,
                      fontSize: 13.0),
                ),
              ),
              Spacer(),
              DownloadFileButton(
                studyMaterial: file,
              ),
            ],
          );
        }),
        width: MediaQuery.of(context).size.width * (0.85),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.files.isEmpty
          ? [NoDataContainer(titleKey: noFilesUploadedKey)]
          : widget.files
              .map((file) => _buildFileDetailsContainer(file))
              .toList(),
    );
  }
}

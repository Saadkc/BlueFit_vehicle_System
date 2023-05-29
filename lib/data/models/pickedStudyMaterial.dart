import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

class PickedStudyMaterial {
  final String fileName;
  final int
      pickedStudyMaterialTypeId; // 1 = file_upload , 2 = youtube_link , 3 = video_upload
  final String? youTubeLink;
  final PlatformFile? videoThumbnailFile;
  final PlatformFile? studyMaterialFile;

  PickedStudyMaterial(
      {required this.fileName,
      required this.pickedStudyMaterialTypeId,
      this.studyMaterialFile,
      this.videoThumbnailFile,
      this.youTubeLink});

  Future<Map<String, dynamic>> toJson() async {
    Map<String, dynamic> json = {};
    json['type'] = pickedStudyMaterialTypeId;
    json['name'] = fileName;

    if (pickedStudyMaterialTypeId != 2) {
      if (studyMaterialFile != null) {
        json['file'] = await MultipartFile.fromFile(studyMaterialFile!.path!);
      }
    }
    if (pickedStudyMaterialTypeId != 1) {
      if (videoThumbnailFile != null) {
        json['thumbnail'] =
            await MultipartFile.fromFile(videoThumbnailFile!.path!);
      }
    }
    if (pickedStudyMaterialTypeId == 2) {
      json['link'] = youTubeLink;
    }

    return json;
  }
}

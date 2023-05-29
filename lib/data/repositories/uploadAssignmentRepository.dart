import 'package:dio/dio.dart';
import 'package:eschool_teacher/utils/api.dart';

class UploadAssignmentRepository {
  AssignmentRepository() {
    dio = Dio();
  }

  late Dio dio;

  Future<void> uploadassignment(
      {required int assignmentId,
      required int classSelectionId,
      required int subjectId,
      required String name,
      required String dateTime,
      String? instruction,
      int? points,
      bool? resubmission,
      int? extraDayForResubmission,
      List? files}) async {
    try {
      var body = {
        "assignment_id": assignmentId,
        "class_section_id": classSelectionId,
        "subject_id": subjectId,
        "name": name,
        "due_date": dateTime,
        "instructions": instruction,
        "points": points,
        "resubmission": resubmission,
        "extra_days_for_resubmission": extraDayForResubmission,
        "file": files,
      };
      if (instruction!.isEmpty) {
        body.remove("instructions");
      }
      if (points == 0) {
        body.remove("points");
      }
      if (resubmission == false) {
        body.remove("extra_days_for_resubmission");
      }
      if (files!.isEmpty) {
        body.remove("file");
      }
      await Api.post(body: body, url: Api.uploadassignment, useAuthToken: true);
    } catch (e) {
      ApiException(e.toString());
    }
  }
}

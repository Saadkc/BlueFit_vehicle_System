import 'package:dio/dio.dart';
import 'package:eschool_teacher/data/models/announcement.dart';
import 'package:eschool_teacher/utils/api.dart';
import 'package:file_picker/file_picker.dart';

class AnnouncementRepository {
  Future<Map<String, dynamic>> fetchAnnouncements(
      {int? page, required int subjectId, required int classSectionId}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page ?? 0,
        "subject_id": subjectId,
        "class_section_id": classSectionId
      };
      if (queryParameters['page'] == 0) {
        queryParameters.remove("page");
      }

      final result = await Api.get(
          url: Api.getAnnouncement,
          useAuthToken: true,
          queryParameters: queryParameters);

      return {
        "announcements": (result['data']['data'] as List)
            .map((e) => Announcement.fromJson(Map.from(e)))
            .toList(),
        "totalPage": result['data']['last_page'] as int,
        "currentPage": result['data']['current_page'] as int,
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> createAnnouncement(
      {required String title,
      required String description,
      required List<PlatformFile> attachments,
      required int classSectionId,
      required int subjectId}) async {
    try {
      List<MultipartFile> files = [];
      for (var file in attachments) {
        files.add(await MultipartFile.fromFile(file.path!));
      }
      Map<String, dynamic> body = {
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "title": title,
        "description": description,
        "file": files
      };
      if (files.isEmpty) {
        body.remove('file');
      }
      if (description.isEmpty) {
        body.remove('description');
      }

      await Api.post(
          body: body, url: Api.createAnnouncement, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> updateAnnouncement(
      {required String title,
      required String description,
      required List<PlatformFile> attachments,
      required int classSectionId,
      required int subjectId,
      required int announcementId}) async {
    try {
      List<MultipartFile> files = [];
      for (var file in attachments) {
        files.add(await MultipartFile.fromFile(file.path!));
      }
      Map<String, dynamic> body = {
        "announcement_id": announcementId,
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "title": title,
        "description": description,
        "file": files
      };
      if (files.isEmpty) {
        body.remove('file');
      }
      if (description.isEmpty) {
        body.remove('description');
      }

      await Api.post(
          body: body, url: Api.updateAnnouncement, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteAnnouncement(int announcementId) async {
    try {
      await Api.post(
          body: {"announcement_id": announcementId},
          url: Api.deleteAnnouncement,
          useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

import 'package:eschool_teacher/data/models/lesson.dart';
import 'package:eschool_teacher/utils/api.dart';

class LessonRepository {
  Future<void> createLesson(
      {required String lessonName,
      required int classSectionId,
      required int subjectId,
      required String lessonDescription,
      required List<Map<String, dynamic>> files}) async {
    try {
      Map<String, dynamic> body = {
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "name": lessonName,
        "description": lessonDescription
      };

      if (files.isNotEmpty) {
        body['file'] = files;
      }

      await Api.post(body: body, url: Api.createLesson, useAuthToken: true);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Lesson>> getLessons(
      {required int classSectionId, required int subjectId}) async {
    try {
      final result = await Api.get(
          url: Api.getLessons,
          useAuthToken: true,
          queryParameters: {
            "class_section_id": classSectionId,
            "subject_id": subjectId
          });
      return (result['data'] as List)
          .map((lesson) => Lesson.fromJson(Map.from(lesson)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> deleteLesson({required int lessonId}) async {
    try {
      await Api.post(
        body: {"lesson_id": lessonId},
        url: Api.deleteLesson,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> updateLesson(
      {required String lessonName,
      required int lessonId,
      required int classSectionId,
      required int subjectId,
      required String lessonDescription,
      required List<Map<String, dynamic>> files}) async {
    try {
      Map<String, dynamic> body = {
        "class_section_id": classSectionId,
        "subject_id": subjectId,
        "name": lessonName,
        "description": lessonDescription,
        "lesson_id": lessonId
      };

      if (files.isNotEmpty) {
        body['file'] = files;
      }

      await Api.post(
        body: body,
        url: Api.updateLesson,
        useAuthToken: true,
      );
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

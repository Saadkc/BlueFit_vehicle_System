import 'package:eschool_teacher/data/models/guardianDetails.dart';
import 'package:eschool_teacher/data/models/result.dart';
import 'package:eschool_teacher/data/models/student.dart';
import 'package:eschool_teacher/data/models/studentResult.dart';
import 'package:eschool_teacher/utils/api.dart';

import '../models/exam.dart';

class StudentRepository {
  Future<List<Student>> getStudentsByClassSection(
      {required int classSectionId}) async {
    try {
      final result = await Api.get(
          url: Api.getStudentsByClassSection,
          useAuthToken: true,
          queryParameters: {"class_section_id": classSectionId});

      return (result['data'] as List)
          .map((e) => Student.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getStudentsMoreDetails(
      {required int studentId}) async {
    try {
      final result = await Api.get(
          url: Api.getStudentsMoreDetails,
          useAuthToken: true,
          queryParameters: {"student_id": studentId});

      return {
        "fatherDetails": (result['father_data'] as List)
            .map((details) => GuardianDetails.fromJson(Map.from(details)))
            .toList()
            .first,
        "motherDetails": (result['mother_data'] as List)
            .map((details) => GuardianDetails.fromJson(Map.from(details)))
            .toList()
            .first,
        "guardianDetails": result['gurdian_data'] != null
            ? (result['gurdian_data'] as List)
                .map((details) => GuardianDetails.fromJson(Map.from(details)))
                .toList()
                .first
            : GuardianDetails.fromJson(Map.from({})),
        "totalPresent": result['total_present'],
        "totalAbsent": result['total_absent'],
        "todayAttendance": result['today_attendance'],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch exams list
  Future<List<Exam>> fetchExamsList(
      {required int examStatus, int? studentID, int? publishStatus}) async {
    try {
      var queryParameter = {
        'status': examStatus,
        'student_id': studentID ?? 0,
      };

      if (publishStatus != null) queryParameter['publish'] = publishStatus;

      final result = await Api.get(
          url: Api.examList,
          useAuthToken: true,
          queryParameters: queryParameter);

      return (result['data'] as List)
          .map((e) => Exam.fromExamJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch time-table of particular exam
  Future<List<ExamTimeTable>> fetchExamTimeTable({required int examId}) async {
    try {
      final result = await Api.get(
          url: Api.examTimeTable,
          useAuthToken: true,
          queryParameters: {"exam_id": examId});

      return (result['data'][0]['timetable'] as List)
          .map((e) => ExamTimeTable.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch student Exam result list
  Future<Map<String, dynamic>> fetchExamResults(
      {int? page, required int studentId}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "page": page ?? 0,
        'student_id': studentId
      };
      if (queryParameters['page'] == 0) {
        queryParameters.remove('page');
      }
      final result = await Api.get(
          url: Api.examResults,
          useAuthToken: true,
          queryParameters: queryParameters);

      return {
        "results": ((result['data'] ?? []) as List)
            .map((result) => Result.fromJson(Map.from(result)))
            .toList()
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to update subject marks by subjectId
  Future<Map<String, dynamic>> updateSubjectMarksBySubjectId(
      {required int examId,
      required int subjectId,
      required Map<String, dynamic> bodyParameter}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "exam_id": examId,
        'subject_id': subjectId
      };
      final result = await Api.post(
          body: bodyParameter,
          url: Api.submitExamMarksBySubjectId,
          useAuthToken: true,
          queryParameters: queryParameters);

      return {'error': result['error'], 'message': result['message']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to update subject marks by studentID
  Future<Map<String, dynamic>> updateSubjectMarksByStudentId(
      {required int examId,
      required int studentId,
      required Map<String, dynamic> bodyParameter}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "exam_id": examId,
        'student_id': studentId
      };
      final result = await Api.post(
          body: bodyParameter,
          url: Api.submitExamMarksByStudentId,
          useAuthToken: true,
          queryParameters: queryParameters);

      return {'error': result['error'], 'message': result['message']};
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch Student completed exam list with Result
  Future<List<StudentResult>> fetchStudentCompletedExamListWithResult({
    required int studentId,
  }) async {
    try {
      Map<String, dynamic> queryParameters = {'student_id': studentId};

      final result = await Api.get(
          url: Api.getStudentResultList,
          useAuthToken: true,
          queryParameters: queryParameters);

      return ((result['data'] ?? []) as List)
          .map((result) => StudentResult.fromJson(Map.from(result)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

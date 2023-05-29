import 'dart:io';

import 'package:dio/dio.dart';
import 'package:eschool_teacher/utils/constants.dart';
import 'package:eschool_teacher/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool_teacher/utils/hiveBoxKeys.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApiException implements Exception {
  String errorMessage;

  ApiException(this.errorMessage);

  @override
  String toString() {
    return errorMessage;
  }
}

class Api {
  static Map<String, dynamic> headers() {
    final String jwtToken = Hive.box(authBoxKey).get(jwtTokenKey) ?? "";
print('token is $jwtToken');
    return {"Authorization": "Bearer $jwtToken"};
  }

  //
  //Teacher app apis
  //
  static String login = "${databaseUrl}teacher/login";
  static String forgotPassword = "${databaseUrl}forgot-password";
  static String logout = "${databaseUrl}logout";
  static String changePassword = "${databaseUrl}change-password";
  static String getClasses = "${databaseUrl}teacher/classes";
  static String getSubjectByClassSection = "${databaseUrl}teacher/subjects";

  static String getassignment = "${databaseUrl}teacher/get-assignment";
  static String uploadassignment = "${databaseUrl}teacher/update-assignment";
  static String deleteassignment = "${databaseUrl}teacher/delete-assignment";
  static String createassignment = "${databaseUrl}teacher/create-assignment";
  static String createLesson = "${databaseUrl}teacher/create-lesson";
  static String getLessons = "${databaseUrl}teacher/get-lesson";
  static String deleteLesson = "${databaseUrl}teacher/delete-lesson";
  static String updateLesson = "${databaseUrl}teacher/update-lesson";

  static String getTopics = "${databaseUrl}teacher/get-topic";
  static String deleteStudyMaterial = "${databaseUrl}teacher/delete-file";
  static String deleteTopic = "${databaseUrl}teacher/delete-topic";
  static String updateStudyMaterial = "${databaseUrl}teacher/update-file";
  static String createTopic = "${databaseUrl}teacher/create-topic";
  static String updateTopic = "${databaseUrl}teacher/update-topic";
  static String getAnnouncement = "${databaseUrl}teacher/get-announcement";
  static String createAnnouncement = "${databaseUrl}teacher/send-announcement";
  static String deleteAnnouncement =
      "${databaseUrl}teacher/delete-announcement";
  static String updateAnnouncement =
      "${databaseUrl}teacher/update-announcement";
  static String getStudentsByClassSection =
      "${databaseUrl}teacher/student-list";

  static String getStudentsMoreDetails =
      "${databaseUrl}teacher/student-details";

  static String getAttendance = "${databaseUrl}teacher/get-attendance";
  static String submitAttendance = "${databaseUrl}teacher/submit-attendance";
  static String timeTable = "${databaseUrl}teacher/teacher_timetable";
  static String examList = "${databaseUrl}teacher/get-exam-list";
  static String examTimeTable = "${databaseUrl}teacher/get-exam-details";
  static String examResults = "${databaseUrl}teacher/exam-marks";
  static String submitExamMarksBySubjectId = "${databaseUrl}teacher/submit-exam-marks/subject";
  static String submitExamMarksByStudentId = "${databaseUrl}teacher/submit-exam-marks/student";
  static String getStudentResultList = "${databaseUrl}teacher/get-student-result";

  static String getReviewAssignment =
      "${databaseUrl}teacher/get-assignment-submission";

  static String updateReviewAssignmet =
      "${databaseUrl}teacher/update-assignment-submission";

  static String settings = "${databaseUrl}settings";

  static String holidays = "${databaseUrl}holidays";

  //Api methods

  static Future<Map<String, dynamic>> post({
    required Map<String, dynamic> body,
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    Function(int, int)? onSendProgress,
    Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final Dio dio = Dio();
      final FormData formData =
          FormData.fromMap(body, ListFormat.multiCompatible);
      print('url is $url and query $queryParameters and $useAuthToken');
      final response = await dio.post(url,
          data: formData,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
          options: useAuthToken ? Options(headers: headers()) : null);

      if (response.data['error']) {
        print(response.data);
        throw ApiException(response.data['code'].toString());
      }
      return Map.from(response.data);
    } on DioError catch (e) {
      print(e.error);
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      print(e.toString());
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    print('called');
    try {
      //
      final Dio dio = Dio();
      final response = await dio.get(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);
print('url is $url and query $queryParameters and $useAuthToken');
      if (response.data['error']) {
        print(response.data['error']);
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioError catch (e) {
      print('error is ${e.response}');
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      print(e.toString());
      throw ApiException(e.errorMessage);
    } catch (e) {
      print(e.toString());
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }

  static Future<void> download(
      {required String url,
      required CancelToken cancelToken,
      required String savePath,
      required Function updateDownloadedPercentage}) async {
    try {
      final Dio dio = Dio();
      await dio.download(url, savePath, cancelToken: cancelToken,
          onReceiveProgress: ((count, total) {
        updateDownloadedPercentage((count / total) * 100);
      }));
    } on DioError catch (e) {
      throw ApiException(e.error is SocketException
          ? ErrorMessageKeysAndCode.noInternetCode
          : ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } on ApiException catch (e) {
      throw ApiException(e.errorMessage);
    } catch (e) {
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageKey);
    }
  }
}

import 'package:dio/dio.dart';
import 'package:eschool/data/models/academicYear.dart';
import 'package:eschool/data/models/attendanceDay.dart';
import 'package:eschool/data/models/coreSubject.dart';
import 'package:eschool/data/models/electiveSubject.dart';
import 'package:eschool/data/models/exam.dart';
import 'package:eschool/data/models/fees.dart';
import 'package:eschool/data/models/paidFees.dart';
import 'package:eschool/data/models/parent.dart';
import 'package:eschool/data/models/result.dart';
import 'package:eschool/data/models/timeTableSlot.dart';
import 'package:eschool/utils/stripeService.dart';
import 'package:eschool/utils/api.dart';
import 'package:eschool/utils/errorMessageKeysAndCodes.dart';
import 'package:eschool/utils/hiveBoxKeys.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentRepository {
  //LocalDataSource
  Future<void> setLocalCoreSubjects(List<CoreSubject> subjects) async {
    final box = Hive.box(studentSubjectsBoxKey);
    List<Map<String, dynamic>> jsonSubjects =
        subjects.map((e) => e.toJson()).toList();

    box.put(coreSubjectsHiveKey, jsonSubjects);
  }

  Future<void> setLocalElectiveSubjects(List<ElectiveSubject> subjects) async {
    final box = Hive.box(studentSubjectsBoxKey);
    List<Map<String, dynamic>> jsonSubjects =
        subjects.map((e) => e.toJson()).toList();

    box.put(electiveSubjectsHiveKey, jsonSubjects);
  }

  List<CoreSubject> getLocalCoreSubjects() {
    final coreSubjects =
        (Hive.box(studentSubjectsBoxKey).get(coreSubjectsHiveKey) ?? [])
            as List;

    return coreSubjects
        .map((e) => CoreSubject.fromJson(json: Map.from(e)))
        .toList();
  }

  List<ElectiveSubject> getLocalElectiveSubjects() {
    final electiveSubjects =
        (Hive.box(studentSubjectsBoxKey).get(electiveSubjectsHiveKey) ?? [])
            as List;

    return electiveSubjects
        .map((e) => ElectiveSubject.fromJson(
            electiveSubjectGroupId: 0, json: Map.from(e)))
        .toList();
  }

  Future<Map<String, dynamic>> fetchSubjects() async {
    try {
      final result =
          await Api.get(url: Api.studentSubjects, useAuthToken: true);

      final coreSubjects = (result['data']['core_subject'] as List)
          .map((e) => CoreSubject.fromJson(json: Map.from(e ?? {})))
          .toList();

      //If class have any elective subjects then of key of elective subject will be there
      //if elective subject key has empty list means student has not slected any
      //elective subjctes

      //If there is not electvie subjects key in result means no elective subjects
      //in given class
      final electiveSubjects =
          ((result['data']['elective_subject'] ?? []) as List)
              .map((e) => ElectiveSubject.fromJson(
                  electiveSubjectGroupId: 0, json: Map.from(e['subject'])))
              .toList();

      return {
        "coreSubjects": coreSubjects,
        "electiveSubjects": electiveSubjects,
        "doesClassHaveElectiveSubjects":
            result['data']['elective_subject'] == null ? false : true
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> selectElectiveSubjects(
      {required Map<int, List<int>> electedSubjectGroups}) async {
    try {
      final electedSubjectGroupIds = electedSubjectGroups.keys
          .map((key) => {"id": key, "subject_id": electedSubjectGroups[key]})
          .toList();

      final body = {"subject_group": electedSubjectGroupIds};
      await Api.post(
          url: Api.selectStudentElectiveSubjects,
          useAuthToken: true,
          body: body);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchParentDetails() async {
    try {
      final result = await Api.get(
        url: Api.parentDetailsOfStudent,
        useAuthToken: true,
      );

      return {
        "mother": Parent.fromJson(Map.from(result['data']['mother'])),
        "father": Parent.fromJson(Map.from(result['data']['father'])),
        "guardian": Parent.fromJson(Map.from(result['data']['guardian'])),
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<TimeTableSlot>> fetchTimeTable(
      {required bool useParentApi, required int childId}) async {
    try {
      final result = await Api.get(
          url: useParentApi
              ? Api.getStudentTimetableParent
              : Api.studentTimeTable,
          useAuthToken: true,
          queryParameters: useParentApi ? {"child_id": childId} : null);

      return (result['data'] as List)
          .map((e) => TimeTableSlot.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchExamResults(
      {int? page, required bool useParentApi, required int childId}) async {
    try {
      Map<String, dynamic> queryParameters = {"page": page ?? 0};
      if (queryParameters['page'] == 0) {
        queryParameters.remove('page');
      }
      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }
      final result = await Api.get(
          url: useParentApi ? Api.getStudentResultsParent : Api.studentResults,
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

  Future<Map<String, dynamic>> fetchAttendance(
      {required int month,
      required int year,
      required bool useParentApi,
      required int childId}) async {
    try {
      Map<String, dynamic> queryParameters = {
        "month": month,
        "year": year,
      };

      if (useParentApi) {
        queryParameters.addAll({"child_id": childId});
      }

      final result = await Api.get(
        url: useParentApi
            ? Api.getStudentAttendanceParent
            : Api.getStudentAttendance,
        queryParameters: queryParameters,
        useAuthToken: true,
      );

      return {
        "attendanceDays": (result['data']['attendance'] as List)
            .map((attendance) => AttendanceDay.fromJson(Map.from(attendance)))
            .toList(),
        "academicYear": AcademicYear.fromJson(
            Map.from(result['data']['session_year'] ?? {}))
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch exams list
  Future<List<Exam>> fetchExamsList(
      {required bool useParentApi,
      required int childId,
      required int examStatus}) async {
    try {
      final result = await Api.get(
          url:
              useParentApi ? Api.getStudentExamListParent : Api.studentExamList,
          useAuthToken: true,
          queryParameters: useParentApi
              ? {"child_id": childId, 'status': examStatus}
              : {'status': examStatus});

      return (result['data'] as List)
          .map((e) => Exam.fromExamJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  //
  //This method is used to fetch time-table of particular exam
  Future<List<ExamTimeTable>> fetchExamTimeTable(
      {required bool useParentApi,
      required int childId,
      required int examId}) async {
    try {
      final result = await Api.get(
          url: useParentApi
              ? Api.getStudentExamDetailsParent
              : Api.studentExamDetails,
          useAuthToken: true,
          queryParameters: useParentApi
              ? {"child_id": childId, "exam_id": examId}
              : {"exam_id": examId});

      return (result['data'] as List)
          .map((e) => ExamTimeTable.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<PaidFees>> fetchFeesList({required int childId}) async {
    try {
      final result = await Api.get(
          url: Api.getPaidFeesListParent,
          useAuthToken: true,
          queryParameters: {
            "child_id": childId,
          });
      print("response -- ${result['data'] as List}");
      return (result['data'] as List)
          .map((e) => PaidFees.fromJson(Map.from(e)))
          .toList();
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> sendFeesReceipt({required int feesPaidId}) async {
    try {
      final result = await Api.get(
          url: Api.sendFeesPaidReceiptParent,
          useAuthToken: true,
          queryParameters: {"fees_paid_id": feesPaidId});

      return (result['message'] as String);
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<List<Fees>> fetchDetailedFees({required int classSectionId}) async {
    //<Fees>
    try {
      final result = await Api.get(
          url: Api.getStudentClassFeesParent,
          useAuthToken: true,
          queryParameters: {
            "class_section_id": classSectionId,
          });

      print("fees details ${result['data']} - ${result['due_data']}");
      List<Fees> tempList = (result['data'] as List)
          .map((e) => Fees.fromFeesJson(Map.from(e), dueData: false))
          .toList();
      if (result['due_data'] != null)
        tempList.add(
            Fees.fromFeesJson(Map.from(result['due_data']), dueData: true));
      return tempList;
    } catch (e) {
      print("exception @ FeesDetails ${e.toString()}");
      throw ApiException(e.toString());
    }
  }

  Future<Map> setFeesChoices(
      {required List<int> types, required int childId}) async {
    try {
      final body = {"fees_type_id": types};

      final result = await Api.post(
          body: body,
          url: Api.addFeesChoiceParent,
          useAuthToken: true,
          queryParameters: {"child_id": childId});
      return result["payment_gateway_details"];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<void> setFeesTransactionStatus(
      {required String transactionId,
      // required int status,
      required int childId,
      String? paymentId,
      String? paymentSignature}) async {
    try {
      await Api.post(
          url: Api.setFeesTransactionStatusParent,
          useAuthToken: true,
          body: {
            "transaction_id": transactionId,
            "child_id": childId,
            //both for razorpay only
            if (paymentId != null) "payment_id": paymentId,
            if (paymentSignature != null) "payment_signature": paymentSignature,
          });
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<String> confirmStripePayment(
      {required String paymentIntentId,
      required String paymentSecretKey}) async {
    try {
      var response =
          await Dio().post('${StripeService.paymentApiUrl}/$paymentIntentId',
              options: Options(headers: {
                'Authorization': 'Bearer $paymentSecretKey',
                'Content-Type': 'application/x-www-form-urlencoded'
              }));
      var getdata = Map.from(response.data);
      final statusOfTransaction = (getdata['status'] ?? "").toString();
      return statusOfTransaction;
    } on PlatformException catch (err) {
      print(err.toString());
      throw ApiException(
          StripeService.getPlatformExceptionErrorResult(err).message ??
              ErrorMessageKeysAndCode.defaultErrorMessageCode);
    } catch (error) {
      print(error.toString());
      throw ApiException(ErrorMessageKeysAndCode.defaultErrorMessageCode);
    }
  }
}

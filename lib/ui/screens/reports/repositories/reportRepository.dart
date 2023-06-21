import 'package:eschool/ui/screens/reports/models/assignmentList.dart';
import 'package:eschool/ui/screens/reports/models/examList.dart';

import 'package:eschool/utils/api.dart';

class ReportRepository {
  Future<Map<String, dynamic>> getExamOnlineReport({
    int? page,
    required int subjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    try {
      final result = await Api.get(
          url: (useParentApi)
              ? Api.parentOnlineExamReport
              : Api.studentOnlineExamReport,
          useAuthToken: true,
          queryParameters: {
            'subject_id': subjectId,
            if (page != 0) 'page': page,
            if (useParentApi) 'child_id': childId,
          });
      print("Exam Report - ${result['data']}");
      final resultData = result['data'];
      return {
        "examList": ExamList.fromJson(Map.from(resultData['exam_list'])),
        "attempted": resultData['attempted'],
        "missedExams": resultData['missed_exams'],
        "totalExams": resultData['total_exams'],
        "percentage": resultData['percentage'],
        "totalObtainedMarks": resultData['total_obtained_marks'],
        "totalMarks": resultData['total_marks'],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> getAssignmentReport({
    int? page,
    required int subjectId,
    required int childId,
    required bool useParentApi,
  }) async {
    try {
      final result = await Api.get(
          url: (useParentApi)
              ? Api.parentAssignmentReport
              : Api.studentAssignmentReport,
          useAuthToken: true,
          queryParameters: {
            if (subjectId != 0) 'subject_id': subjectId,
            if (page != 0) 'page': page,
            if (useParentApi) 'child_id': childId,
          });
      final resultData = result['data'];
      return {
        "assignmentList": AssignmentList.fromJson(
            resultData['submitted_assignment_with_points_data']),
        "assignments": resultData['assignments'],
        "submittedAssignments": resultData['submitted_assignments'],
        "unsubmittedAssignments": resultData['unsubmitted_assignments'],
        "percentage": resultData['percentage'],
        "totalObtainedPoints": resultData['total_obtained_points'],
        "totalPoints": resultData['total_points'],
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

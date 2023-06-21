import 'package:eschool/data/models/academicYear.dart';
import 'package:eschool/data/models/studentClass.dart';

class PaidFees {
  late final int id;
  late final int parentId;
  late final int studentId;
  late final int classId;
  late final int mode;
  late final String transactionId;
  late final String chequeNumber;
  late final double totalAmount;
  late final DateTime dateOfPayment;
  late final int sessionYearId;
  late final AcademicYear academicYear;
  late final StudentClass stClass;
  bool? isProcessing;

  PaidFees(
      {required this.id,
      required this.parentId,
      required this.studentId,
      required this.classId,
      required this.mode,
      required this.transactionId,
      required this.chequeNumber,
      required this.totalAmount,
      required this.dateOfPayment,
      required this.sessionYearId,
      required this.academicYear,
      required this.stClass,
      this.isProcessing = false});

  PaidFees.fromJson(Map<String, dynamic> json) {
    id = json["id"] ?? 0;
    parentId = json["parent_id"] ?? 0;
    studentId = json["student_id"] ?? 0;
    classId = json["class_id"] ?? 0;
    mode = json["mode"] ?? 0;
    transactionId = json["transaction_id"] ?? '';
    chequeNumber = json["cheque_no"] ?? '';
    totalAmount = double.parse(json["total_amount"].toString());
    dateOfPayment = json['date'] == null
        ? DateTime.now()
        : DateTime.parse(json['date'].toString());
    sessionYearId = json["session_year_id"] ?? 0;
    academicYear = AcademicYear.fromJson(json['session_year'] ?? {});
    stClass = StudentClass.fromJson(json["class"] ?? {});
    isProcessing = false; //use it for Receipt Download process
  }
}

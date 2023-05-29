import 'package:eschool_teacher/data/models/academicYear.dart';

class AppConfiguration {
  AppConfiguration({
    required this.appLink,
    required this.iosAppLink,
    required this.appVersion,
    required this.iosAppVersion,
    required this.forceAppUpdate,
    required this.appMaintenance,
  });
  late final String appLink;
  late final String iosAppLink;
  late final String appVersion;
  late final String iosAppVersion;
  late final String forceAppUpdate;
  late final String appMaintenance;
  late final AcademicYear academicYear;
  late final String schoolName;
  late final String schoolTagline;

  AppConfiguration.fromJson(Map<String, dynamic> json) {
    appLink = json['teacher_app_link'] ?? "";
    iosAppLink = json['teacher_ios_app_link'] ?? "";
    appVersion = json['teacher_app_version'] ?? "";
    iosAppVersion = json['teacher_ios_app_version'] ?? "";
    forceAppUpdate = json['teacher_force_app_update'] ?? "0";
    appMaintenance = json['teacher_app_maintenance'] ?? "0";
    schoolName = json['school_name'] ?? "";
    schoolTagline = json['school_tagline'] ?? "";
    academicYear = AcademicYear.fromJson(json['session_year'] ?? {});
  }
}

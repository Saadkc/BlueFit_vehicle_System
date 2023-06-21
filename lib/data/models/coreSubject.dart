import 'package:eschool/data/models/subject.dart';

class CoreSubject extends Subject {
  late final int classId;

  CoreSubject.fromJson({required Map<String, dynamic> json})
      : super.fromJson(Map.from(json['subject'] ?? {})) {
    classId = json['class_id'] ?? 0;
  }
}

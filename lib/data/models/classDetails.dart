import 'package:eschool_teacher/data/models/medium.dart';

class ClassDetails {
  ClassDetails({
    required this.id,
    required this.name,
    required this.mediumId,
    required this.medium,
  });
  late final int id;
  late final String name;
  late final int mediumId;
  late final Medium medium;

  ClassDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? -1;
    name = json['name'] ?? "";
    mediumId = json['medium_id'] ?? -1;
    medium = Medium.fromJson(json['medium'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['medium_id'] = mediumId;
    _data['medium'] = medium.toJson();
    return _data;
  }
}

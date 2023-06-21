class Subject {
  Subject({
    required this.id,
    required this.name,
    required this.code,
    required this.bgColor,
    required this.image,
    required this.mediumId,
    required this.type,
  });
  late final int id;
  late final String name;
  late final String code;
  late final String bgColor;
  late final String image;
  late final int mediumId;
  late final String type;
  late final bool isSubjectImageSvg;

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    code = json['code'] ?? "";
    bgColor = json['bg_color'] ?? "";
    image = json['image'] ?? "";
    mediumId = json['medium_id'] ?? 0;
    type = json['type'] ?? "";
    final imageUrlParts = image.split(".");
    isSubjectImageSvg = imageUrlParts.last.toLowerCase() == "svg";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['code'] = code;
    _data['bg_color'] = bgColor;
    _data['image'] = image;
    _data['medium_id'] = mediumId;
    _data['type'] = type;
    return _data;
  }
}

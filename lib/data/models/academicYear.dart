class AcademicYear {
  AcademicYear({
    required this.id,
    required this.name,
    required this.defaultValue,
    required this.startDate,
    required this.endDate,
  });
  late final int id;
  late final String name;
  late final int defaultValue;
  late final DateTime startDate;
  late final DateTime endDate;

  AcademicYear.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    name = json['name'] ?? "";
    defaultValue = json['default'] ?? -1;
    startDate = json['start_date'] == null
        ? DateTime.now()
        : DateTime.parse(json['start_date'].toString());
    endDate = json['end_date'] == null
        ? DateTime.now()
        : DateTime.parse(json['end_date'].toString());
  }
}

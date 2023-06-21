import 'package:eschool/data/models/student.dart';

class Parent {
  Parent({
    required this.id,
    required this.gender,
    required this.email,
    required this.children,
    required this.mobile,
    required this.image,
    required this.dob,
    required this.status,
    required this.userId,
    required this.occupation,
    required this.lastName,
    required this.firstName,
  });
  late final int id;
  late final String gender;
  late final String email;
  late final String mobile;
  late final String image;
  late final String dob;
  late final int status;
  late final int userId;
  late final String occupation;
  late final String lastName;
  late final String firstName;
  late final List<Student> children;
  late final String currentAddress;

  late final String permanentAddress;

  //

  Parent.fromJson(Map<String, dynamic> json) {
    currentAddress = json['current_address'] ?? "";
    permanentAddress = json['permanent_address'] ?? "";
    id = json['id'] ?? 0;
    gender = json['gender'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    dob = json['dob'] ?? "";

    status = json['status'] ?? 0;
    userId = json['user_id'] ?? 0;
    occupation = json['occupation'] ?? "";
    lastName = json['last_name'] ?? "";
    firstName = json['first_name'] ?? "";
    children = json['children'] == null
        ? []
        : (json['children'] as List)
            .map((studentJson) => Student.fromJson(Map.from(studentJson)))
            .toList();
  }

  String getFullName() {
    return "$firstName $lastName";
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['gender'] = gender;
    _data['email'] = email;
    _data['mobile'] = mobile;
    _data['image'] = image;
    _data['dob'] = dob;
    _data['status'] = status;
    _data['user_id'] = userId;
    _data['occupation'] = occupation;
    _data['last_name'] = lastName;
    _data['first_name'] = firstName;
    _data['children'] = children.map((student) => student.toJson()).toList();
    return _data;
  }
}

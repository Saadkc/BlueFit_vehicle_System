class GuardianDetails {
  GuardianDetails({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.gender,
    required this.email,
    required this.mobile,
    required this.image,
    required this.dob,
    required this.occupation,
  });
  late final int id;
  late final int userId;
  late final String firstName;
  late final String lastName;
  late final String gender;
  late final String email;
  late final String mobile;
  late final String image;
  late final String dob;
  late final String occupation;

  GuardianDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    userId = json['user_id'] ?? 0;
    firstName = json['first_name'] ?? "";
    lastName = json['last_name'] ?? "";
    gender = json['gender'] ?? "";
    email = json['email'] ?? "";
    mobile = json['mobile'] ?? "";
    image = json['image'] ?? "";
    dob = json['dob'] ?? "";
    occupation = json['occupation'] ?? "";
  }

  String getFullName() {
    return "$firstName $lastName";
  }
}
